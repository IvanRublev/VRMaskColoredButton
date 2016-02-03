//
//  VRMaskColoredButton.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/25/16.
//
//

import UIKit

///  Button class with images painted dynamicly. Is configurable via property inspector of Interface Builder.
///
///  Images for normal, highlighted and selected states are painted by applying color to mask image. The image property value for the appropriate state is treated as grayscale mask and normalColor, highlightedColor or selectedColor property value is used respectively to paint the image for the state. The background images are created the same way.
///
///  Properties named selectedHighlighted... could be used for fast setting of images and colors for selected with highlighted state.
///
@IBDesignable
public class VRMaskColoredButton: VRMaskColoredButtonBase {

    var fetchImagesForStates: [UIControlState] = [.Normal, .Highlighted, .Selected]
    
    /// Color applied to the button's image for normal control state. If not set then the tintColor property value is used.
    @IBInspectable dynamic public var normalColor: UIColor? {
        willSet { setImageColor(newValue, forState: .Normal) }
    }
    /// Color applied to the button's background image for normal control state. By default is black color.
    @IBInspectable dynamic public var normalBackgroundColor: UIColor? {
        willSet { setBackgroundImageColor(newValue, forState: .Normal) }
    }
    /// Color applied to the button's image for highlighted control state. If not set then normalColor is used.
    @IBInspectable dynamic public var highlightedColor: UIColor? {
        willSet { setImageColor(newValue, forState: .Highlighted) }
    }
    /// Color applied to the button's background image for highlighted control state. By default normalBackgroundColor is used.
    @IBInspectable dynamic public var highlightedBackgroundColor: UIColor? {
        willSet { setBackgroundImageColor(newValue, forState: .Highlighted) }
    }
    /// Color applied to the button's image for selected control state. If not set then normalColor is used.
    @IBInspectable dynamic public var selectedColor: UIColor? {
        willSet { setImageColor(newValue, forState: .Selected) }
    }
    /// Color applied to the button's background image for selected control state. By default normalBackgroundColor is used.
    @IBInspectable dynamic public var selectedBackroundColor: UIColor? {
        willSet { setBackgroundImageColor(newValue, forState: .Selected) }
    }
    /// Color applied to the button's image for selected with highlighted control state. If not set then normalColor is used.
    @IBInspectable dynamic public var selectedHighlightedColor: UIColor? {
        willSet { setImageColor(newValue, forState: UIControlState.Selected.union(.Highlighted)) }
    }
    /// Color applied to the button's background image for selected with highlighted control state. By default normalBackgroundColor is used.
    @IBInspectable dynamic public var selectedHighlightedBackroundColor: UIColor? {
        willSet { setBackgroundImageColor(newValue, forState: UIControlState.Selected.union(.Highlighted)) }
    }
    /// Image to be set for selected with highlighted state
    @IBInspectable dynamic public var selectedHighlightedImage: UIImage? {
        willSet { setImage(newValue, forState: UIControlState.Selected.union(.Highlighted)) }
    }
    /// Background image to be set for selected with highlighted state
    @IBInspectable dynamic public var selectedHighlightedBackgroundImage: UIImage? {
        willSet { setBackgroundImage(newValue, forState: UIControlState.Selected.union(.Highlighted)) }
    }
    
    // MARK: -
    // MARK: Default colors
    override public func imageColorForState(state: UIControlState) -> UIColor? {
        if let color = super.imageColorForState(state) {
            return color
        } else { // return defaults
            if state == .Normal {
                return tintColor
            } else {
                return imageColorForState(.Normal)
            }
        }
    }
    
    override public func backgroundImageColorForState(state: UIControlState) -> UIColor? {
        if let backgroundColor = super.backgroundImageColorForState(state) {
            return backgroundColor
        } else { // return defaults
            if state == .Normal {
                return UIColor.blackColor()
            } else {
                return backgroundImageColorForState(.Normal)
            }
        }
    }
    
    override public var tintColor: UIColor! {
        didSet {
            if hasImageColorForState(.Normal) == false { // then tintColor is used as default value to paint images
                updateImages()
                updateBackgroundImages()
            }
        }
    }

    // MARK: -
    // MARK: Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Collect images that were set via IB
        var imagesForState = [UIControlState : UIImage]()
        var backgroundImagesForState = [UIControlState : UIImage]()
        for state in fetchImagesForStates  {
            if let superImage = super.imageForState(state) {
                if superImage != imagesForState[.Normal] {
                    imagesForState[state] = superImage
                }
            }
            if let superBackgroundImage = super.backgroundImageForState(state) {
                if superBackgroundImage != backgroundImagesForState[.Normal] {
                    backgroundImagesForState[state] = superBackgroundImage
                }
            }
        }
        // Fill mask images
        maskImageForState = imagesForState
        backgroundMaskImageForState = backgroundImagesForState
    }

    // MARK: -
    // MARK: Intercept images to make them mask images
    override public func setImage(image: UIImage?, forState state: UIControlState) {
        maskImageForState[state] = image
    }
    
    override public func imageForState(state: UIControlState) -> UIImage? {
        return maskImageForState[state]
    }
    
    override public func setBackgroundImage(image: UIImage?, forState state: UIControlState) {
        backgroundMaskImageForState[state] = image
    }
    
    override public func backgroundImageForState(state: UIControlState) -> UIImage? {
        return backgroundMaskImageForState[state]
    }
    
}