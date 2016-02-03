//
//  SegmentedView.m
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "SegmentedView.h"
#import "ColorOptions.h"

@interface SegmentedView ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *separators;
@end

@implementation SegmentedView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set the background mask images for Normal control state.
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 6, 0, 6);
    UIImage *leftImage =  [[UIImage imageNamed:@"toolbar sel left"] resizableImageWithCapInsets:insets];
    UIImage *middleImage = [[UIImage imageNamed:@"toolbar sel middle"] resizableImageWithCapInsets:insets];
    UIImage *rightImage = [[UIImage imageNamed:@"toolbar sel right"] resizableImageWithCapInsets:insets];
    [self.segLeftButton setBackgroundImage:leftImage forState: UIControlStateNormal];
    [self.segMidButton setBackgroundImage:middleImage forState: UIControlStateNormal];
    [self.segRightButton setBackgroundImage:rightImage forState: UIControlStateNormal];
    
    for (VRMaskColoredButton *segButton in self.segments) {
        // Set the color of background images for normal and selected states.
        [segButton setBackgroundImageColor:segmentedButtonBackgroundColor forState:UIControlStateNormal];
        [segButton setBackgroundImageColor:segmentedButtonBackgroudSelectedColor forState:UIControlStateSelected]; // mask image from Normal state will be used automatically
        // Set title colors inverted.
        [segButton setTitleColor:segmentedButtonBackgroudSelectedColor forState:UIControlStateNormal];
        [segButton setTitleColor:segmentedButtonBackgroundColor forState:UIControlStateSelected];
    }
    
    for (UIView *separatorView in self.separators) {
        separatorView.backgroundColor = segmentedButtonBackgroudSelectedColor;
    }

}

@end
