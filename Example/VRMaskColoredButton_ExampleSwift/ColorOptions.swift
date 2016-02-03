//
//  ColorOptions.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/31/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

import UIKit

// Colors for ViewController's buttons are defined here.

enum ColorOption: Int {
    case Pink, Green, Yellow
}
let colorForColorOption: [ColorOption : UIColor] = [
    .Pink   : UIColor(red: 255/255.0, green: 40/255.0, blue: 81/255.0, alpha: 1.0),
    .Green  : UIColor(red: 68/255.0, green: 219/255.0, blue: 94/255.0, alpha: 1.0),
    .Yellow : UIColor(red: 255/255.0, green: 205/255.0, blue: 0.0, alpha: 1.0)
]
let titleForColorOption: [ColorOption : String] = [
    .Pink   : "Pink",
    .Green  : "Green",
    .Yellow : "Yellow"
]

let buttonIconColor = UIColor.whiteColor()
let segmentedButtonBackgroundColor = UIColor(white: 1.0, alpha: 0.86)
let segmentedButtonBackgroudSelectedColor = UIColor(red: 0, green: 118/255.0, blue: 255.0, alpha: 1.0)
