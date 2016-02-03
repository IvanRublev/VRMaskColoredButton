//
//  UIImageMaskColor.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/22/16.
//
//

import UIKit

public extension UIImage {    
    /**
     Paints and returns image by treating receiver as a mask and applying foreground and background colors to it. Receiver must be a grayscale image. Mask's blocks equal to 1 will be painted with foreground color, blocks equal to 0 will be painted with background color. Blocks between 0 and 1 will be painted with the gradient color taken between foreground and background colors respectively. The pained image will have the same size and scale as the receiver.
     
     - parameter foregroundColor: Color that will be used to paint pixels appropriate to receiver's white pixels.
     - parameter backgroundColor: When specified this color will be used to fill background of painted image. Clear color by default.
     
     - returns: Painted image.
     */
    func imageByApplyingColor(foregroundColor: UIColor, backgroundColor: UIColor = UIColor.clearColor()) -> UIImage {
        let painter = VRImagePainter()
        painter.maskImage = self
        painter.foregroundColor = foregroundColor
        painter.backgroundColor = backgroundColor
        return painter.image()
    }
    
    /**
     Paints and returns image by treating receiver as mask then applying provided foreground color and merging with provided background image. The created image will have the same size and scale as the receiver.
     
     - parameter foregroundColor: Color that will be used to painit pixels appropriate to receiver's white pixels.
     - parameter backgroundImage: Image to merge the colored image with.

     - returns: Painted image.
     */
    func imageByApplyingColor(foregroundColor: UIColor, mergeWithBackgroundImage image: UIImage?) -> UIImage {
        let painter = VRImagePainter()
        painter.maskImage = self
        painter.foregroundColor = foregroundColor
        painter.backgroundImage = image
        return painter.image()
    }
}