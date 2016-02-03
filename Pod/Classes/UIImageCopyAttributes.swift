//
//  UIImageCopyAttributes.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/29/16.
//
//

import UIKit
import CoreGraphics

public extension UIImage {
    /**
     Makes and returns the image object with same underlying Quartz data but attributes copied from another image object.
     
     Values for following properties will not be copied: traitCollection, imageAsset.
     
     Animated images are not supported.
     
     - parameter image: The other image object to copy attributes from.
     
     - returns: An image object, or nil if the method could not make the image from the specified data.
     */
    func imageByCopyingAttributesFrom(image: UIImage) -> UIImage? {
        
        if self.CGImage == nil {
            return nil
        }
        var result = UIImage(CGImage: self.CGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        result = result.resizableImageWithCapInsets(image.capInsets, resizingMode: image.resizingMode)
        
        if UIEdgeInsetsEqualToEdgeInsets(image.alignmentRectInsets, UIEdgeInsetsZero) == false {
            result = result.imageWithAlignmentRectInsets(image.alignmentRectInsets)
        }
        
        if #available(iOS 9.0, *) {
            if image.flipsForRightToLeftLayoutDirection && !result.flipsForRightToLeftLayoutDirection {
                result = result.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        
        return result
    }
}