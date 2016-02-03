//
//  ColorOptions.m
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "ColorOptions.h"

NSDictionary *colorForColorOption =
  @{@(ColorOptionPink) : [UIColor colorWithRed: 255/255.0 green: 40/255.0 blue: 81/255.0 alpha: 1.0],
    @(ColorOptionGreen) : [UIColor colorWithRed: 68/255.0 green: 219/255.0 blue: 94/255.0 alpha: 1.0],
    @(ColorOptionYellow) : [UIColor colorWithRed: 255/255.0 green: 205/255.0 blue: 0.0 alpha: 1.0]};

NSDictionary *titleForColorOption =
  @{@(ColorOptionPink) : @"Pink",
    @(ColorOptionGreen) : @"Green",
    @(ColorOptionYellow) : @"Yellow"};

UIColor *buttonIconColor = [UIColor whiteColor];
UIColor *segmentedButtonBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.86];
UIColor *segmentedButtonBackgroudSelectedColor = [UIColor colorWithRed: 0 green: 118/255.0 blue: 255.0 alpha: 1.0];
