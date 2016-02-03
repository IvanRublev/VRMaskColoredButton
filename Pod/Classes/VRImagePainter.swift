//
//  VRImagePainter.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/2/16.
//
//

import UIKit
import CoreGraphics

func ==(lhs: VRImagePainter, rhs: VRImagePainter) -> Bool {
    return lhs.maskImage == rhs.maskImage &&
        lhs.foregroundColor == rhs.foregroundColor &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.backgroundImage == rhs.backgroundImage
}

/// Class to paint image using mask image, foreground color, background color or background image.
class VRImagePainter: Hashable {
    var maskImage: UIImage!
    var foregroundColor: UIColor!
    var backgroundColor: UIColor = UIColor.clearColor()
    var backgroundImage: UIImage?

    var hashValue: Int  {
        func swipeBits(value: Int) -> Int {
            let uValue = unsafeBitCast(value, UInt.self)
            let valueSize = UInt(sizeofValue(uValue)*Int(CHAR_BIT))
            let shift = valueSize/2
            let luValue = uValue << shift
            let ruValue = uValue >> shift
            let swiped = unsafeBitCast(luValue | ruValue, Int.self)
            return swiped
        }

        return maskImage.hashValue ^
            swipeBits(foregroundColor.hashValue) ^
            backgroundColor.hashValue ^
            (backgroundImage ?? 0).hashValue
    }
    
    /**
     Paints and returns image by applying colors to mask image and merging with background image if set.
     
     - returns: Painted image.
     */
    func image() -> UIImage {
        let paintedImage = imageByPaintingMask()
        
        var assembledImage = paintedImage
        if let theBackgroundImage = backgroundImage {
            assembledImage = paintedImage.imageByMergingWith([theBackgroundImage])
        }
        
        let attributedImage = assembledImage.imageByCopyingAttributesFrom(maskImage)!
        return attributedImage
    }
    
    private func imageByPaintingMask() -> UIImage {
        let imageRef = maskImage.CGImage
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        let maskRectPoints = CGRectMake(0, 0, CGFloat(width), CGFloat(height));
        // Invert image for use as image mask below
        UIGraphicsBeginImageContext(maskRectPoints.size)
        let invContext = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(invContext, 0.0, maskRectPoints.size.height);
        CGContextScaleCTM(invContext, 1.0, -1.0);
        CGContextSetFillColorWithColor(invContext, UIColor.whiteColor().CGColor); // fill black
        CGContextFillRect(invContext, maskRectPoints);
        CGContextSetBlendMode(invContext, CGBlendMode.Difference) // blend with image
        CGContextDrawImage(invContext, maskRectPoints, imageRef)
        let invertedImageRef = CGBitmapContextCreateImage(invContext)!
        UIGraphicsEndImageContext()
        // Make image mask
        let imageMaskRef = CGImageMaskCreate(
            width,
            height,
            CGImageGetBitsPerComponent(invertedImageRef),
            CGImageGetBitsPerPixel(invertedImageRef),
            CGImageGetBytesPerRow(invertedImageRef),
            CGImageGetDataProvider(invertedImageRef),
            nil,
            false);
        // Apply colors
        UIGraphicsBeginImageContext(maskRectPoints.size);
        let context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0.0, maskRectPoints.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, maskRectPoints);
        CGContextSetFillColorWithColor(context, foregroundColor.CGColor);
        CGContextClipToMask(context, maskRectPoints, imageMaskRef);
        CGContextFillRect(context, maskRectPoints);
        // get image
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return coloredImage
    }
}