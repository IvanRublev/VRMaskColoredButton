//
//  ColorOptions.h
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ColorOption) {
    ColorOptionPink,
    ColorOptionGreen,
    ColorOptionYellow,
};

FOUNDATION_EXPORT NSDictionary *colorForColorOption;
FOUNDATION_EXPORT NSDictionary *titleForColorOption;

FOUNDATION_EXPORT UIColor *buttonIconColor;
FOUNDATION_EXPORT UIColor *segmentedButtonBackgroundColor;
FOUNDATION_EXPORT UIColor *segmentedButtonBackgroudSelectedColor;
