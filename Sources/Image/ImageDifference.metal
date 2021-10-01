//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#include <metal_stdlib>

using namespace metal;

/*
 * Does a strict pixel by pixel comparison and generates a resulting image.
 */
kernel void difference_strict(
                       texture2d<float, access::read>   golden  [[ texture(0) ]],
                       texture2d<float, access::read>   compare [[ texture(1) ]],
                       texture2d<float, access::write>  out     [[ texture(2) ]],
                       uint2                            pos     [[ thread_position_in_grid ]])
{
    if (pos.x >= out.get_width() || pos.y >= out.get_height()) {
        return;
    }
    
    const auto goldenPixel = golden.read(pos);
    const auto comparePixel = compare.read(pos);
    const auto differenceRGBA = float4(fabs(goldenPixel.x - comparePixel.x),
                                       fabs(goldenPixel.y - comparePixel.y),
                                       fabs(goldenPixel.z - comparePixel.z),
                                       fabs(goldenPixel.w - comparePixel.w));
    
    const auto differenceMax = fmax(fmax(differenceRGBA.x, differenceRGBA.y), fmax(differenceRGBA.z, differenceRGBA.w));
    const auto outPixel = float4(differenceMax, 0, 0, differenceMax > 0 ? 1.0 : 0);
    out.write(outPixel, pos);
}
