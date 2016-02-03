//
//  ViewController.m
//  VRMaskColoredButton_ExampleObjC
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "ColorOptions.h"
#import "Jukebox.h"
#import "SegmentedView.h"
#import "ViewController.h"
@import VRMaskColoredButton;

@interface ViewController () <JukeboxDelegate>
@property (nonatomic) Jukebox *jukebox;

@property (strong, nonatomic) IBOutlet VRMaskColoredButton *muteButton;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;

@property (strong, nonatomic) IBOutlet VRMaskColoredButton *backwardButton;
@property (strong, nonatomic) IBOutlet VRMaskColoredButton *playButton;
@property (strong, nonatomic) IBOutlet VRMaskColoredButton *forwardButton;
@property (strong, nonatomic) IBOutletCollection(VRMaskColoredButton) NSArray *playbackControls;
@property (strong, nonatomic) IBOutlet SegmentedView *segmentedView;

@property (nonatomic) ColorOption selectedColorOption;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.jukebox = [Jukebox new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[VRMaskColoredButton appearance] setNormalColor:buttonIconColor]; // Configure every button's image color via appearance proxy.
    
    [self setButtonTitleAndTag:self.segmentedView.segLeftButton withColorOption:ColorOptionPink];
    [self setButtonTitleAndTag:self.segmentedView.segMidButton withColorOption:ColorOptionGreen];
    [self setButtonTitleAndTag:self.segmentedView.segRightButton withColorOption:ColorOptionYellow];
    
    self.selectedColorOption = ColorOptionPink;
    self.jukebox.delegate = self;
}

- (void)setButtonTitleAndTag:(UIButton *)button withColorOption:(ColorOption)option {
    button.tag = option;
    [button setTitle:titleForColorOption[@(option)] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Changing the color of playback controls
- (void)setSelectedColorOption:(ColorOption)selectedColorOption {
    _selectedColorOption = selectedColorOption;
    
    // Update the selected states of segmented buttons
    for (VRMaskColoredButton *segButton in self.segmentedView.segments) {
        segButton.selected = (segButton.tag == selectedColorOption);
    }
    // Change the color of playback buttons background image according to selected color option.
    UIColor *buttonBackgroundColor = colorForColorOption[@(selectedColorOption)];
    for (VRMaskColoredButton *playbackButton in self.playbackControls) {
        [playbackButton setBackgroundImageColor:buttonBackgroundColor forState:UIControlStateNormal];
        // Make the button's image and backround image colors to exchange in highlighted state.
        [playbackButton setBackgroundImageColor:buttonIconColor forState: UIControlStateHighlighted];
        [playbackButton setImageColor:buttonBackgroundColor forState: UIControlStateHighlighted];
        [playbackButton setBackgroundImageColor:buttonIconColor forState: UIControlStateSelected | UIControlStateHighlighted];
        [playbackButton setImageColor:buttonBackgroundColor forState: UIControlStateSelected | UIControlStateHighlighted];
    }
}

- (IBAction)segButtonPressed:(UIButton *)sender {
    self.selectedColorOption = (ColorOption)sender.tag;
}


#pragma mark -
#pragma mark Control jukebox
- (IBAction)controlButtonPressed:(UIButton *)sender {
    if (sender == self.playButton) {
        self.jukebox.play = !self.jukebox.play;
        
    } else if (sender == self.backwardButton) {
        [self.jukebox prevSong];
        
    } else if (sender == self.forwardButton) {
        [self.jukebox nextSong];
        
    } else if (sender == self.muteButton) {
        self.jukebox.muted = !self.jukebox.muted;
        
    } else {
        NSAssert(YES, @"Unhandled control");
    }
}

- (void)jukeboxPlayWasStarted {
    self.playButton.selected = YES;
    [self updateSongTitle];
}

- (void)jukeboxPlayWasPaused {
    self.playButton.selected = NO;
    [self updateSongTitle];
}

- (void)jukeboxSongWasChanged:(NSUInteger)currentSong {
    self.backwardButton.enabled = currentSong > 0;
    self.forwardButton.enabled = currentSong < self.jukebox.songTitles.count-1;
    [self updateSongTitle];
}

- (void)jukeboxVolume:(BOOL)muted {
    self.muteButton.selected = muted;
}

- (void)updateSongTitle {
    NSString *text = [NSString stringWithFormat:@"%lu. %@", self.jukebox.currentSong+1, self.jukebox.songTitles[self.jukebox.currentSong]];
    if (self.jukebox.play) {
        text = [text stringByAppendingString:@" *"];
    }
    self.songTitle.text = text;
}

@end
