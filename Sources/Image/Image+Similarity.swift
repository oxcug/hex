//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if canImport(UIKit)
import UIKit.UIImage
typealias Image = UIImage
public typealias HXImage = UIImage

#elseif canImport(AppKit)
import AppKit.NSImage
public typealias HXImage = NSImage
#else
    #error("unknown platform!")
#endif

import Metal

enum ComponentKind {
    case red, green, blue, alpha
}

struct Component {
    var component: ComponentKind
    var length: Int
}

extension Component: Equatable {
    static let r8 = Component(component: .red, length: 8)
    static let g8 = Component(component: .green, length: 8)
    static let b8 = Component(component: .blue, length: 8)
    static let a8 = Component(component: .alpha, length: 8)
}

typealias ComponentLayout = [Component]


extension ComponentLayout {
    var mtlPixelFormat: MTLPixelFormat {
        switch self {
        case [.r8, .g8, .b8, .a8]:
            return .rgba8Unorm
        case [.a8, .r8, .g8, .b8]:
            return .a8Unorm
        default:
            fatalError("Unknown function prefix for image layout pattern \(self)")
        }
    }
    
    var imageDifferenceFunctionPrefix: String {
        switch self {
        case [.r8, .g8, .b8, .a8]:
            return "RGBA8888"
        case [.a8, .r8, .g8, .b8]:
            return "ARGB8888"
        default:
            fatalError("Unknown function prefix for image layout pattern \(self)")
        }
    }
}

extension CGImage {
    
    var componentLayout: ComponentLayout {
        var out = ComponentLayout()
        // Setup RGB base on colorspace:
        switch colorSpace?.model {
        case .rgb:
            out.append(contentsOf: [
                .init(component: .red, length: bitsPerComponent),
                .init(component: .green, length: bitsPerComponent),
                .init(component: .blue, length: bitsPerComponent)
            ])
        default:
            fatalError("Unhandled colorSpace: \(String(describing: colorSpace))")
        }
        
        
        // Add alpha info:
        switch alphaInfo {
        case .last: fallthrough
        case .premultipliedLast:
            out.append(.init(component: .alpha, length: bitsPerComponent))
        case .premultipliedFirst:
            out.insert(.init(component: .alpha, length: bitsPerComponent), at: 0)
        default:
            fatalError("Unhandled alphaInfo: \(alphaInfo.rawValue)")
        }
        
        return out
    }
}

//extension Image {
//    func resized(to size: CGSize) -> Image {
//        return UIGraphicsImageRenderer(size: size).image { _ in
//            draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
//}

extension CGImage {
    func mtlTexture(using device: MTLDevice) -> MTLTexture? {
        let data      = dataProvider!.data!
        let ptr       = CFDataGetBytePtr(data)!
        let descriptor = MTLTextureDescriptor()
        descriptor.width = width
        descriptor.height = height
        descriptor.pixelFormat =  componentLayout.mtlPixelFormat
        let texture = device.makeTexture(descriptor: descriptor)
        let region = MTLRegion(origin: .init(), size: .init(width: descriptor.width, height: descriptor.height, depth: 1))
        texture?.replace(region: region, mipmapLevel: 0, withBytes: ptr, bytesPerRow: descriptor.width * 4)
        return texture
    }
}

extension HXImage {
    
    public func difference(from other: HXImage) -> HXImage {
        guard size == other.size else {
            fatalError("Failed to rebind result buffer!")
        }
        
        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Failed to create metal device.") }
        guard let queue = device.makeCommandQueue() else { fatalError("Failed to create metal Command Queue.") }
        
        #if canImport(AppKit)
        guard   let goldenCGImage   = cgImage(forProposedRect: nil, context: .current, hints: nil),
                let compareCGImage  = other.cgImage(forProposedRect: nil, context: .current, hints: nil) else {
                    fatalError("Failed to get CGImage!")
                }
        #else
        guard   let goldenCGImage   = cgImage,
                let compareCGImage  = other.cgImage else {
                    fatalError("Failed to get CGImage!")
                }
        #endif
        
        guard
            let lib = try? device.makeDefaultLibrary(bundle: .module),
              let computeFunc = lib.makeFunction(name: "difference_strict"),
              let commandBuffer = queue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder(),
              let state = try? device.makeComputePipelineState(function: computeFunc)
        else {
            fatalError("Failed to setup metal.")
        }
        
        encoder.setComputePipelineState(state)
        let resultImageWidth = Int(size.width)
        let resultImageHeight = Int(size.height)
        
        let goldenTexture = goldenCGImage.mtlTexture(using: device)
        let compareTexture = compareCGImage.mtlTexture(using: device)
        
        let differenceDescriptor = MTLTextureDescriptor()
        differenceDescriptor.pixelFormat = .rgba8Unorm
        differenceDescriptor.width = goldenCGImage.width
        differenceDescriptor.height = goldenCGImage.height
        differenceDescriptor.usage = [.shaderWrite, .shaderRead]
        let differenceTexture = device.makeTexture(descriptor: differenceDescriptor)
        
        encoder.setTexture(goldenTexture, index: 0)
        encoder.setTexture(compareTexture, index: 1)
        encoder.setTexture(differenceTexture, index: 2)
        
        let w = state.threadExecutionWidth
        let h = state.maxTotalThreadsPerThreadgroup / w
        let threadsPerThreadgroup = MTLSizeMake(w, h, 1)
        let threadsPerGrid = MTLSize(width: resultImageWidth, height: resultImageHeight, depth: 1)
                
        encoder.dispatchThreads(threadsPerGrid,
                                threadsPerThreadgroup: threadsPerThreadgroup)
        
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let bytesPerRow = Int(size.width) * 4
        let outSize = MTLSize(width: differenceDescriptor.width, height: differenceDescriptor.height, depth: 1)
        let region = MTLRegion(origin: .init(), size: outSize)
        let bytesPerPixel = 4
        let bitsPerPixel = 8 * bytesPerPixel
        let bufferLength = outSize.width * outSize.height * bytesPerPixel
        var resultBufferData = [UInt8](repeating: 0, count: bufferLength)
        differenceTexture!.getBytes(&resultBufferData, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let deltaImageData = CFDataCreateWithBytesNoCopy(CFAllocatorGetDefault().takeUnretainedValue(), &resultBufferData, bufferLength, nil)!
        let deltaImageDataProvider = CGDataProvider(data: deltaImageData)!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let deltaImageCG = CGImage(width: Int(size.width),
                                   height: Int(size.height),
                                   bitsPerComponent: 8,
                                   bitsPerPixel: bitsPerPixel,
                                   bytesPerRow: bytesPerRow,
                                   space: colorSpace,
                                   bitmapInfo: goldenCGImage.bitmapInfo,
                                   provider: deltaImageDataProvider,
                                   decode: nil,
                                   shouldInterpolate: true,
                                   intent: .defaultIntent)!
        #if canImport(AppKit)
        let deltaImage = HXImage(cgImage: deltaImageCG, size: size)
        #else
        let deltaImage = HXImage(cgImage: deltaImageCG)
        #endif
        return deltaImage
    }
}
