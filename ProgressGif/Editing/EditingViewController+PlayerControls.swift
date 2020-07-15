//
//  EditingViewController+PlayerControls.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit
import AVFoundation

extension EditingViewController: PlayerControlsDelegate {
    func backPressed() {
        if let currentTime = playerView.player?.currentTime() {
            let seconds = CMTimeGetSeconds(currentTime)
            let back5seconds = max(0, seconds - 5)
            
            if back5seconds >= 0 {
                playerView.hasFinishedVideo = false
            }
            
            if let currentTimescale = playerView.player?.currentItem?.duration.timescale {
                let newCMTime = CMTimeMakeWithSeconds(back5seconds, preferredTimescale: currentTimescale)
                playerView.player?.seek(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30))
                
                if playerView.playingState == .paused {
                    let backSliderValue = Float(back5seconds / asset.duration)
                    playerControlsView.customSlider.setValue(backSliderValue, animated: false)
                }
            }
        }
    }
    
    func forwardPressed() {
        if !hasInitializedPlayer {
            /// if the user hasn't pressed play yet, but already pressed the forward button
            jumpForward5()
        } else {
            if let currentTime = playerView.player?.currentTime() {
                let seconds = CMTimeGetSeconds(currentTime)
                let forward5seconds = min(asset.duration, seconds + 5)
                
                if forward5seconds == asset.duration {
                    playerView.hasFinishedVideo = true
                    playerView.updateSliderProgress?.finishedVideo()
                }
                
                if let currentTimescale = playerView.player?.currentItem?.duration.timescale {
                    let newCMTime = CMTimeMakeWithSeconds(forward5seconds, preferredTimescale: currentTimescale)
                    playerView.player?.seek(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30))
                    
                    if playerView.playingState == .paused {
                        let forwardSliderValue = Float(forward5seconds / asset.duration)
                        playerControlsView.customSlider.setValue(forwardSliderValue, animated: false)
                    }
                }
            }
        }
    }
    
    func sliderChanged(value: Float, event: SliderEvent) {
        switch event {
        case .began:
            if !hasInitializedPlayer {
                startSlider()
            } else {
                /// pause first
                playerView.pause(fromSlider: true)
            }
        case .moved:
            if let currentTimescale = playerView.player?.currentItem?.duration.timescale {
                let timeStamp = value * Float(asset.duration)
                let time = CMTimeMakeWithSeconds(Float64(timeStamp), preferredTimescale: currentTimescale)
                playerView.player?.seek(to: time, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30))
            }
        case .ended:
            /// slider went to end
            if value >= 1.0 {
                playerView.pause()
                playerView.hasFinishedVideo = true
                playerView.updateSliderProgress?.finishedVideo()
            } else if playerView.hasFinishedVideo == true {
                /// if the slider went to the end, then slid back again
                playerView.hasFinishedVideo = false
            }
            if playerView.playingState == .playing {
                playerView.play()
            }
        }
    }
    
    func changedPlay(playingState: PlayingState) {
        if playingState == .playing {
            playVideo()
        } else {
            pauseVideo()
        }
    }
    
    
}
