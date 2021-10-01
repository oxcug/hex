//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation
import SwiftUI

//#if canImport(UIKit)
//import UIKit.UIImage
//typealias HostingController = UIHostingController
//typealias EdgeInsets = UIEdgeInsets
//#elseif canImport(AppKit)
//import AppKit.NSImage
//typealias HostingController = NSHostingController
//typealias EdgeInsets = NSEdgeInsets
//#else
//    #error("unknown platform!")
//#endif
//
//struct PortraitDevice {
//    
//    var pointResolution: CGSize
//    
//    var scaleFactor: UInt
//    
//    var safeEdgeInsets: EdgeInsets
//    
//    var horizontalSizeClass: UserInterfaceSizeClass
//    
//    var verticalSizeClass: UserInterfaceSizeClass
//    
//    enum iPhone {
//        static let iphone13Pro = PortraitDevice(pointResolution: CGSize(width: 390, height: 844),
//                                                       scaleFactor: 3,
//                                                       safeEdgeInsets: EdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
//                                                       horizontalSizeClass: .compact,
//                                                       verticalSizeClass: .regular)
//    }
//    
//    enum iPad {
//        static let mini6thGen = PortraitDevice(pointResolution: CGSize(width: 744, height: 1133),
//                                                          scaleFactor: 2,
//                                                          safeEdgeInsets: EdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
//                                                          horizontalSizeClass: .compact,
//                                                          verticalSizeClass: .regular)
//    }
//}
//
//enum DevicePreset {
//    case freeform
//    case portrait(PortraitDevice)
//    case landscape(PortraitDevice)
//}
//
//class MockWindow: UIWindow {
//    
//    var preset: DevicePreset
//    override var safeAreaInsets: EdgeInsets {
//        switch preset {
//        case .freeform:
//            return .zero
//        case .portrait(let device):
//            return device.safeEdgeInsets
//        case .landscape(let portrait):
//            return UIEdgeInsets(top: portrait.safeEdgeInsets.left,
//                                left: portrait.safeEdgeInsets.left,
//                                bottom: portrait.safeEdgeInsets.left,
//                                right: portrait.safeEdgeInsets.left)
//        }
//    }
//    
//    override var frame: CGRect {
//        get {
//            switch preset {
//            case .freeform:
//                guard let rootViewController = rootViewController else { return .zero }
//                return CGRect(origin: .zero, size: rootViewController.view.sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity)))
//            case .portrait(let portraitDevice):
//                return CGRect(origin: .zero, size: portraitDevice.pointResolution)
//            case .landscape(let portraitDevice):
//                return CGRect(origin: .zero, size: CGSize(width: portraitDevice.pointResolution.height, height: portraitDevice.pointResolution.width))
//            }
//        }
//        set {  }
//    }
//    
//    override var rootViewController: UIViewController? {
//        didSet {
//            rootViewController?.view.frame = CGRect(origin: .zero, size: frame.size)
//        }
//    }
//    
//    required init(preset: DevicePreset) {
//        self.preset = preset
//        super.init(frame: .zero)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension View {
//    func snapshot(device: DevicePreset = .freeform) -> UIImage {
//        let dummyWindow = MockWindow(preset: device)
//        let controller = HostingController(rootView: self)
//        dummyWindow.makeKeyAndVisible()
//        dummyWindow.rootViewController = controller
//        controller.view.backgroundColor = .clear
//        
//        let renderer = UIGraphicsImageRenderer(bounds: controller.view.frame)
//        let img = renderer.image { imageContext in
//            controller.view.layer.render(in: imageContext.cgContext)
//        }
//        
//        return img
//    }
//}
//
