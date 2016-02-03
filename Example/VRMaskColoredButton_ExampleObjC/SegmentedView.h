//
//  SegmentedView.h
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

@import UIKit;
@import VRMaskColoredButton;

@interface SegmentedView : UIView
@property (strong, nonatomic) IBOutlet VRMaskColoredButton *segLeftButton;
@property (strong, nonatomic) IBOutlet VRMaskColoredButton *segMidButton;
@property (strong, nonatomic) IBOutlet VRMaskColoredButton *segRightButton;
@property (strong, nonatomic) IBOutletCollection(VRMaskColoredButton) NSArray *segments;
@end
