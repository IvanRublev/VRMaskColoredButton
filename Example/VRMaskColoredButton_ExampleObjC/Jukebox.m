//
//  Jukebox.m
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 2/1/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "Jukebox.h"
@import AVFoundation;

@interface Song: NSObject
@property NSString *title;
@property NSString *fileName;
@end

@implementation Song
+ (instancetype)fileName:(NSString *)aFileName title:(NSString *)aTitle {
    Song *aSong = [Song new];
    aSong.title = aTitle;
    aSong.fileName = aFileName;
    return  aSong;
}
@end


@interface Jukebox () <AVAudioPlayerDelegate>
@property (nonatomic) BOOL _play;
@property (nonatomic) NSUInteger _currentSong;
@property (nonatomic) BOOL _muted;
@property (nonatomic) dispatch_queue_t playQueue;
@property (nonatomic) AVAudioPlayer *player;
@end

@implementation Jukebox

static NSArray *songs;
+ (void)initialize {
    if (self == [Jukebox self]) {
        songs = @[[Song fileName:@"Beat to the Bop" title:@"Beat to the Bop"],
                  [Song fileName:@"bop - hook" title:@"Hook Bop"],
                  [Song fileName:@"Jiga Bop 7" title:@"Jiga Bop"]];
    }
}

- (instancetype)init {
    if ((self = [super init])) {
        self._play = NO;
        self._currentSong = 0;
        self._muted = NO;
        self.playQueue = dispatch_queue_create("play", DISPATCH_QUEUE_CONCURRENT);
        _songTitles = [songs valueForKeyPath:@"title"];
    }
    return self;
}

- (void)set_play:(BOOL)_play {
    if (__play == _play) {
        return;
    }
    __play = _play;
    
    if (_play) {
        [self playCurrentSong];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate jukeboxPlayWasStarted];
        });
    } else {
        [self pauseCurrentSong];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate jukeboxPlayWasPaused];
        });
    }
}

- (void)set_currentSong:(NSUInteger)_currentSong {
    _currentSong = MAX(0, MIN(_currentSong, songs.count-1));
    if (__currentSong == _currentSong) {
        return;
    }
    __currentSong = _currentSong;
    
    [self pauseCurrentSong];
    if (self._play) {
        [self playCurrentSong];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate jukeboxSongWasChanged:_currentSong];
    });
}


#pragma mark -
#pragma mark External interface
- (void)setDelegate:(id<JukeboxDelegate>)delegate {
    _delegate = delegate;
    dispatch_sync(self.playQueue, ^{
        BOOL isPlaying = self._play;
        NSUInteger songNumber = self._currentSong;
        BOOL isMuted = self._muted;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isPlaying) {
                [self.delegate jukeboxPlayWasStarted];
            } else {
                [self.delegate jukeboxPlayWasPaused];
            }
            [self.delegate jukeboxSongWasChanged:songNumber];
            [self.delegate jukeboxVolume:isMuted];
        });
    });
}

- (void)setPlay:(BOOL)play {
    dispatch_barrier_sync(self.playQueue, ^{
        self._play = play;
    });
}

- (BOOL)play {
    __block BOOL play;
    dispatch_sync(self.playQueue, ^{
        play = self._play;
    });
    return play;
}

- (NSUInteger)currentSong {
    __block NSUInteger songNumber;
    dispatch_sync(self.playQueue, ^{
        songNumber = self._currentSong;
    });
    return songNumber;
}

- (void)nextSong {
    dispatch_barrier_sync(self.playQueue, ^{
        self._currentSong++;
    });
}

- (void)prevSong {
    dispatch_barrier_sync(self.playQueue, ^{
        self._currentSong--;
    });
}

- (void)setMuted:(BOOL)muted {
    dispatch_barrier_sync(self.playQueue, ^{
        if (muted == self._muted) {
            return;
        }
        self._muted = muted;
        
        [self setPlayerVolume];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate jukeboxVolume:muted];
        });
    });
}

- (BOOL)muted {
    __block BOOL isMuted;
    dispatch_sync(self.playQueue, ^{
        isMuted = self._muted;
    });
    return isMuted;
}


#pragma mark -
#pragma mark Control AVAudioPlayer
- (void)playCurrentSong {
    NSString *fileName = [(Song *)songs[self._currentSong] fileName];
    NSURL * currentSongURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"m4a"];
    
    AVAudioPlayer *thePlayer = self.player;
    if (thePlayer) {
        if ([thePlayer.url isEqual:currentSongURL]) {
            [thePlayer play];
            return;
        } else {
            [thePlayer stop];
        }
    }
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:currentSongURL error:nil];
    NSAssert(newPlayer, @"Can't initialize AVAudioPlayer");
    newPlayer.delegate = self;
    newPlayer.numberOfLoops = 1;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.player = newPlayer;
    [self setPlayerVolume];
    [self.player play];
}

- (void)pauseCurrentSong {
    AVAudioPlayer *thePlayer = self.player;
    if (thePlayer) {
        [thePlayer pause];
    }
}

- (void)setPlayerVolume {
    AVAudioPlayer *thePlayer = self.player;
    if (thePlayer) {
        thePlayer.volume = (self._muted ? 0.0 : 1.0);
    }
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    dispatch_barrier_sync(self.playQueue, ^{
        if (self._currentSong == songs.count-1) {
            self._play = NO;
            self._currentSong = 0;
            self.player = nil;
            
        } else {
            self._currentSong++;
            
        }
    });
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSAssert(YES, error.description);
}

@end
