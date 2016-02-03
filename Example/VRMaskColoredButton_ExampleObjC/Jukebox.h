//
//  Jukebox.h
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

@import Foundation;

@protocol JukeboxDelegate
- (void)jukeboxPlayWasStarted;
- (void)jukeboxPlayWasPaused;
- (void)jukeboxSongWasChanged:(NSUInteger)currentSong;
- (void)jukeboxVolume:(BOOL)muted;
@end

@interface Jukebox : NSObject
@property (nonatomic, readonly) NSArray *songTitles;
@property (nonatomic, weak) id<JukeboxDelegate> delegate;
@property (nonatomic) BOOL play;
@property (nonatomic, readonly) NSUInteger currentSong;
- (void)nextSong;
- (void)prevSong;
@property (nonatomic) BOOL muted;
@end
