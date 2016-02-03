//
//  ViewController.swift
//  VRMaskColoredButton
//
//  Created by Ivan Rublev on 1/21/16.
//  Copyright (c) 2016 Ivan Rublev. All rights reserved.
//

import UIKit
import VRMaskColoredButton

class ViewController: UIViewController, JukeboxDelegate {

    private let jukebox = Jukebox()
    
    @IBOutlet var muteButton: VRMaskColoredButton!
    @IBOutlet var songTitle: UILabel!

    // Playback controls
    @IBOutlet var backwardButton: VRMaskColoredButton!
    @IBOutlet var playButton: VRMaskColoredButton!
    @IBOutlet var forwardButton: VRMaskColoredButton!
    @IBOutlet var playbackControls: [VRMaskColoredButton]!

    @IBOutlet var segmentedView: SegmentedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VRMaskColoredButton.appearance().normalColor = buttonIconColor // Configure every button's image color via appearance proxy.
        
        setButtonTitleAndTag(segmentedView.segLeftButton, withColorOption: .Pink)
        setButtonTitleAndTag(segmentedView.segMidButton, withColorOption: .Green)
        setButtonTitleAndTag(segmentedView.segRightButton, withColorOption: .Yellow)
        selectedColorOption = .Pink
        jukebox.delegate = self
    }
    
    private func setButtonTitleAndTag(button: UIButton, withColorOption option: ColorOption) {
        button.tag = option.rawValue
        button.setTitle(titleForColorOption[option]!, forState: .Normal)
    }

    // MARK: Changing the color of playback controls
    var selectedColorOption: ColorOption! {
        didSet {
            // Update the selected states of segmented buttons
            for segButton in segmentedView.segments {
                segButton.selected = (segButton.tag == selectedColorOption.rawValue)
            }
            // Change the color of playback buttons background image according to selected color option.
            let buttonBackgroundColor = colorForColorOption[selectedColorOption]
            for playbackButton in playbackControls {
                playbackButton.setBackgroundImageColor(buttonBackgroundColor, forState: .Normal)
                // Make the button's image and backround image colors to exchange in highlighted state.
                playbackButton.setBackgroundImageColor(buttonIconColor, forState: .Highlighted)
                playbackButton.setImageColor(buttonBackgroundColor, forState: .Highlighted)
                playbackButton.setBackgroundImageColor(buttonIconColor, forState: UIControlState.Selected.union(.Highlighted))
                playbackButton.setImageColor(buttonBackgroundColor, forState: UIControlState.Selected.union(.Highlighted))
            }
        }
    }

    @IBAction func segButtonPressed(sender: UIButton) {
        selectedColorOption = ColorOption(rawValue: sender.tag)
    }
    
    // MARK: Control jukebox
    @IBAction func controlButtonPressed(sender: UIButton) {
        switch sender {
        case playButton:
            jukebox.play = !jukebox.play
            
        case backwardButton:
            jukebox.prevSong()
            
        case forwardButton:
            jukebox.nextSong()
        
        case muteButton:
            jukebox.muted = !jukebox.muted
            
        default:
            assertionFailure("Unhandled control")
        }
    }
    
    func jukeboxPlayWasStarted() {
        playButton.selected = true
        updateSongTitle()
    }
    
    func jukeboxPlayWasPaused() {
        playButton.selected = false
        updateSongTitle()
    }
    
    func jukeboxSongWasChanged(currentSong: UInt) {
        backwardButton.enabled = currentSong > 0
        forwardButton.enabled = currentSong < UInt(jukebox.songTitles.count-1)
        updateSongTitle()
    }
    
    func jukeboxVolume(muted: Bool) {
        muteButton.selected = muted
    }

    func updateSongTitle() {
        var text = "\(jukebox.currentSong+1). \(jukebox.songTitles[Int(jukebox.currentSong)])"
        if jukebox.play {
            text += " *"
        }
        songTitle.text = text
    }
}
