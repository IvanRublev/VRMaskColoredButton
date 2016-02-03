//
//  SegmentedView.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/31/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

import UIKit
import VRMaskColoredButton

class SegmentedView: UIView {
    @IBOutlet var segLeftButton: VRMaskColoredButton!
    @IBOutlet var segMidButton: VRMaskColoredButton!
    @IBOutlet var segRightButton: VRMaskColoredButton!
    @IBOutlet var segments: [VRMaskColoredButton]!
    @IBOutlet var separators: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the background mask images for Normal control state.
        let insets = UIEdgeInsetsMake(0, 6, 0, 6)
        let leftImage = UIImage(named: "toolbar sel left")?.resizableImageWithCapInsets(insets)
        let middleImage = UIImage(named: "toolbar sel middle")?.resizableImageWithCapInsets(insets)
        let rightImage = UIImage(named: "toolbar sel right")?.resizableImageWithCapInsets(insets)
        segLeftButton.setBackgroundImage(leftImage, forState: .Normal)
        segMidButton.setBackgroundImage(middleImage, forState: .Normal)
        segRightButton.setBackgroundImage(rightImage, forState: .Normal)

        for segButton in segments {
            // Set the color of background images for normal and selected states.
            segButton.setBackgroundImageColor(segmentedButtonBackgroundColor, forState: .Normal)
            segButton.setBackgroundImageColor(segmentedButtonBackgroudSelectedColor, forState: .Selected) // mask image from Normal state will be used automatically
            // Set title colors inverted.
            segButton.setTitleColor(segmentedButtonBackgroudSelectedColor, forState: .Normal)
            segButton.setTitleColor(segmentedButtonBackgroundColor, forState: .Selected)
        }

        for separatorView in separators {
            separatorView.backgroundColor = segmentedButtonBackgroudSelectedColor
        }
    }
}
