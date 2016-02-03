//
//  Jukebox.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/31/16.
//  Copyright © 2016 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

import Foundation
import AVFoundation

protocol JukeboxDelegate: class {
    func jukeboxPlayWasStarted()
    func jukeboxPlayWasPaused()
    func jukeboxSongWasChanged(currentSong: UInt)
    func jukeboxVolume(muted: Bool)
}

class Jukebox: NSObject, AVAudioPlayerDelegate {
    // MARK: Songs
    struct Song {
        var title: String
        var fileName: String
        init(_ newFileName: String, _ newTitle: String) {
            fileName = newFileName
            title = newTitle
        }
    }
    
    private let songs = [
        Song("Beat to the Bop", "Beat to the Bop"),
        Song("bop - hook", "Hook Bop"),
        Song("Jiga Bop 7", "Jiga Bop")
    ]
    let songTitles: [String]
    
    override init() {
        var titles = [String]()
        for aSong in songs {
            titles.append(aSong.title)
        }
        songTitles = titles
        super.init()
    }

    // MARK: State
    private var _play = false {
        didSet {
            if _play == oldValue {
                return
            }
            if _play == true { // start playing
                self.playCurrentSong()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.jukeboxPlayWasStarted()
                }
                
            } else { // pause playing
                self.pauseCurrentSong()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.jukeboxPlayWasPaused()
                }
                
            }
        }
    }
    private var _currentSong: UInt = 0 {
        didSet {
            _currentSong = UInt(max(0, min(Int(_currentSong), self.songs.count-1)))
            if _currentSong == oldValue {
                return
            } // change song
            pauseCurrentSong()
            if _play {
                playCurrentSong()
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.jukeboxSongWasChanged(self._currentSong)
            }
        }
    }
    private var _muted = false
    private let playQueue = dispatch_queue_create("play", DISPATCH_QUEUE_CONCURRENT)
    
    // MARK: External interface
    weak var delegate: JukeboxDelegate? {
        didSet {
            dispatch_sync(playQueue) {
                let isPlaying = self._play
                let songNumber = self._currentSong
                let isMuted = self._muted
                dispatch_async(dispatch_get_main_queue()) {
                    if isPlaying {
                        self.delegate?.jukeboxPlayWasStarted()
                    } else {
                        self.delegate?.jukeboxPlayWasPaused()
                    }
                    self.delegate?.jukeboxSongWasChanged(songNumber)
                    self.delegate?.jukeboxVolume(isMuted)
                }
            }
        }
    }
    
    var play: Bool {
        set {
            dispatch_barrier_sync(playQueue) {
                self._play = newValue
            }
        }
        get {
            var isPlaying = false
            dispatch_sync(playQueue) {
                isPlaying = self._play
            }
            return isPlaying
        }
    }

    var currentSong: UInt {
        var songNumber: UInt!
        dispatch_sync(playQueue) {
            songNumber = self._currentSong
        }
        return songNumber
    }
    
    func nextSong() {
        dispatch_barrier_sync(playQueue) {
            self._currentSong++
        }
    }

    func prevSong() {
        dispatch_barrier_sync(playQueue) {
            self._currentSong--
        }
    }
    
    var muted: Bool {
        set {
            dispatch_barrier_sync(playQueue) {
                if newValue == self._muted {
                    return
                }
                self._muted = newValue
                self.setPlayerVolume()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.jukeboxVolume(newValue)
                }
            }
        }
        get {
            var isMuted = false
            dispatch_sync(playQueue) {
                isMuted = self._muted
            }
            return isMuted
        }
    }
    
    // MARK: Control AVAudioPlayer
    private var player: AVAudioPlayer!
    private func playCurrentSong() {
        let fileName = songs[Int(_currentSong)].fileName
        let currentSongURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "m4a")!
        
        if let thePlayer = player {
            if thePlayer.url! == currentSongURL {
                thePlayer.play()
                return
            } else { // need to make new player for new song
                thePlayer.stop()
            }
        } // no player, make new one
        
        let newPlayer = try! AVAudioPlayer(contentsOfURL: currentSongURL)
        newPlayer.delegate = self
        newPlayer.numberOfLoops = 1
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        player = newPlayer
        setPlayerVolume()
        player.play()
    }
    
    private func pauseCurrentSong() {
        if let thePlayer = player {
            thePlayer.pause()
        }
    }
    
    private func setPlayerVolume() {
        if let thePlayer = player {
            thePlayer.volume = (_muted == true ? 0.0 : 1.0)
        }
    }
    
    // MARK: AVAudioPlayer delegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        dispatch_barrier_sync(playQueue) {
            if self._currentSong == UInt(self.songs.count-1) { // last song, stop and rewind
                self._play = false
                self._currentSong = 0
                self.player = nil
                
            } else { // play next song
                self._currentSong++
            }
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) throws {
        throw error!
    }
}