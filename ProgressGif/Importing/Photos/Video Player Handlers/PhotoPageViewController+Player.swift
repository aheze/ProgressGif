//
//  PhotoPageViewController+Player.swift
//  ProgressGif
//
//  Created by Zheng on 7/13/20.
//

import UIKit
import AVFoundation
import Photos

/// handle the player controls view
extension PhotoPageViewController: PlayerControlsDelegate {
    func backPressed() {
        if let currentTime = currentViewController.playerView.player?.currentTime() {
            let seconds = CMTimeGetSeconds(currentTime)
            let back5seconds = max(0, seconds - 5)
            
            if back5seconds >= 0 {
                currentViewController.playerView.hasFinishedVideo = false
            }
            
            if let currentTimescale = currentViewController.playerView.player?.currentItem?.duration.timescale {
                let newCMTime = CMTimeMakeWithSeconds(back5seconds, preferredTimescale: currentTimescale)
                
                currentViewController.playerView.seekToTime(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30), completionHandler: { _ in })
                
                if currentViewController.playerView.playingState == .paused {
                    let backSliderValue = Float(back5seconds / currentViewController.asset.duration)
                    playerControlsView.customSlider.setValue(backSliderValue, animated: false)
                }
            }
        }
    }
    
    func forwardPressed() {
        if !currentViewController.hasInitializedPlayer {
            
            /// if the user hasn't pressed play yet, but already pressed the forward button
            currentViewController.jumpForward5()
        } else {
            if let currentTime = currentViewController.playerView.player?.currentTime() {
                let seconds = CMTimeGetSeconds(currentTime)
                let forward5seconds = min(currentViewController.asset.duration, seconds + 5)
                
                if forward5seconds == currentViewController.asset.duration {
                    currentViewController.playerView.hasFinishedVideo = true
                    currentViewController.playerView.updateSliderProgress?.finishedVideo()
                }
                
                if let currentTimescale = currentViewController.playerView.player?.currentItem?.duration.timescale {
                    let newCMTime = CMTimeMakeWithSeconds(forward5seconds, preferredTimescale: currentTimescale)
                    
                    currentViewController.playerView.seekToTime(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30), completionHandler: { _ in })
                    
                    if currentViewController.playerView.playingState == .paused {
                        let forwardSliderValue = Float(forward5seconds / currentViewController.asset.duration)
                        playerControlsView.customSlider.setValue(forwardSliderValue, animated: false)
                    }
                }
            }
        }
    }
    
    func sliderChanged(value: Float, event: SliderEvent) {
        switch event {
        case .began:
            
            if !currentViewController.hasInitializedPlayer {
                currentViewController.startSlider()
            } else {
                /// pause first
                currentViewController.playerView.pause(fromSlider: true)
            }
        case .moved:
            if let currentTimescale = currentViewController.playerView.player?.currentItem?.duration.timescale {
                let timeStamp = value * Float(currentViewController.asset.duration)
                let time = CMTimeMakeWithSeconds(Float64(timeStamp), preferredTimescale: currentTimescale)
                currentViewController.playerView.seekToTime(to: time, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30), completionHandler: { _ in })
            }
        case .ended:
            /// slider went to end
            if value >= 1.0 {
                currentViewController.playerView.pause()
                currentViewController.playerView.hasFinishedVideo = true
                currentViewController.playerView.updateSliderProgress?.finishedVideo()
            } else if currentViewController.playerView.hasFinishedVideo == true {
                /// if the slider went to the end, then slid back again
                currentViewController.playerView.hasFinishedVideo = false
            }
            if currentViewController.playerView.playingState == .playing {
                currentViewController.playerView.play()
            }
        }
    }
    
    func changedPlay(playingState: PlayingState) {
        if playingState == .playing {
            currentViewController.playVideo()
        } else {
            currentViewController.pauseVideo()
        }
    }
}
