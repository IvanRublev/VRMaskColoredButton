//
//  UIImageMerge.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/21/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

import UIKit
import CoreGraphics

public extension UIImage {
    /**
     Creates and returns an image by merging the receiver with provided images. The returned image will have the dimentions of the largest image that takes part in operation. Merging images will be centered.
     
     - parameter images: The array of images to merge with the receiver.
     - parameter onTop:  If true then images will be put on top of the receiver during the merge.
     
     - returns: A new image object.
     */
    func imageByMergingWith(images: [UIImage], onTop: Bool = false) -> UIImage {
        var imagesToDraw = [self]
        imagesToDraw.appendContentsOf(images)
        if onTop == false {
            imagesToDraw = imagesToDraw.reverse()
        }
        
        var imageDimentions: [(Int, Int)] = []
        for anImage in imagesToDraw {
            let imageRef = anImage.CGImage!
            let anImageWidth = CGImageGetWidth(imageRef)
            let anImageHeight = CGImageGetHeight(imageRef)
            imageDimentions.append((anImageWidth, anImageHeight))
        }

        let (maxImageWidth, maxImageHeight) = imageDimentions.reduce((0, 0)) { (curMax, value: (Int, Int)) -> (Int, Int) in
            let newMax = (max(curMax.0, value.0), max(curMax.1, value.1))
            return newMax
        }
        let size = CGSizeMake(CGFloat(maxImageWidth), CGFloat(maxImageHeight))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        for var index=0; index < imagesToDraw.count; index++ {
            let anImage = imagesToDraw[index]
            let width = CGFloat(imageDimentions[index].0)
            let height = CGFloat(imageDimentions[index].1)
            let dx = (size.width-width)/2.0
            let dy = (size.height-height)/2.0
            let anImageRect = CGRectMake(dx, dy, width, height)
            anImage.drawInRect(anImageRect)
        }
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let scaledImage = mergedImage.imageByCopyingAttributesFrom(self)!
        return scaledImage
    }
}