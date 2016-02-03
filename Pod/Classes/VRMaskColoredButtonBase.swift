//
//  VRMaskColoredButtonBase.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/28/16.
//
//

import UIKit

extension UIControlState: Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
}

///  Button class with images that could be painted dynamicly.
///
///  Button images can be set either via standard setImage:forState: or via the pair of setMaskImage:forState: setColor:forState: methods exclusively. In the last case the image is painted by applying color to mask image and passing painted image to setImage:forState: method of the super class.
///  Background images are set the same way.
///
public class VRMaskColoredButtonBase: UIButton {

    // MARK: Configure mask image and colors

    public var maskImageForState = [UIControlState : UIImage]() {
        didSet { updateImages() }
    }
    public var backgroundMaskImageForState = [UIControlState : UIImage]() {
        didSet { updateBackgroundImages() }
    }
    
    private var imageColorForState = [UIControlState: UIColor]()
    private var backgroundImageColorForState = [UIControlState: UIColor]()
    
    public func setImageColor(color: UIColor?, forState state:UIControlState) {
        imageColorForState[state] = color
        updateImages()
    }
    
    public func imageColorForState(state: UIControlState) -> UIColor? {
        return imageColorForState[state]
    }
    
    public func hasImageColorForState(state: UIControlState) -> Bool {
        return imageColorForState[state] != nil
    }
    
    public func setBackgroundImageColor(color: UIColor?, forState state: UIControlState) {
        backgroundImageColorForState[state] = color
        updateBackgroundImages()
    }
    
    public func backgroundImageColorForState(state: UIControlState) -> UIColor? {
        return backgroundImageColorForState[state]
    }
    
    public func hasBackgroundImageColorForState(state: UIControlState) -> Bool {
        return backgroundImageColorForState[state] != nil
    }
    
    // MARK: -
    // MARK: Override superclass methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func setImage(image: UIImage?, forState state: UIControlState) {
        maskImageForState[state] = nil
        super.setImage(image, forState: state)
    }
    
    override public func setBackgroundImage(image: UIImage?, forState state: UIControlState) {
        backgroundMaskImageForState[state] = nil
        super.setBackgroundImage(image, forState: state)
    }
    
    // MARK: -
    // MARK: Paint images
    func updateImages() {
        for aState in Set<UIControlState>(Array(maskImageForState.keys)+Array(imageColorForState.keys)) {
            let maskImage = maskImageForState[aState]
            if aState != .Normal && hasImageColorForState(aState) == false && maskImage == nil {
                continue
            }
            if let aImage = maskImage ?? maskImageForState[.Normal] { // this will be true for .Normal only when mask image is set
                var paintedImage = aImage
                if let aColor = imageColorForState(aState) {
                    paintedImage = aImage.imageByApplyingColor(aColor)
                }
                super.setImage(paintedImage, forState: aState)
            }
        }
    }

    func updateBackgroundImages() {
        for aState in Set<UIControlState>(Array(backgroundMaskImageForState.keys)+Array(backgroundImageColorForState.keys)) {
            let backgroundMaskImage = backgroundMaskImageForState[aState]
            if aState != .Normal && hasBackgroundImageColorForState(aState) == false && backgroundMaskImage == nil {
                continue
            }
            if let aBackgroundImage = backgroundMaskImage ?? backgroundMaskImageForState[.Normal] { // this will be true for .Normal only when background mask image is set
                var paintedBackgroundImage = aBackgroundImage
                if let aBackgroundColor = backgroundImageColorForState(aState) {
                    paintedBackgroundImage = aBackgroundImage.imageByApplyingColor(aBackgroundColor)
                }
                super.setBackgroundImage(paintedBackgroundImage, forState: aState)
            }
        }
    }

}