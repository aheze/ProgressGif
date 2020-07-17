//
//  EditingViewController+PlayerView.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit
import AVFoundation

extension EditingViewController {
    func playVideo() {
        if !hasInitializedPlayer {
            playFromValue(sliderValue: playerControlsView.customSlider.value)
        } else {
            playerView.play()
        }
    }
    
    func playFromValue(sliderValue: Float) {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .playFromValue, value: sliderValue)
        
    }
    
    func pauseVideo() {
        playerView.pause()
    }
    func stopVideo() {
        playerView.pause()
        playerView.player = nil
        hasInitializedPlayer = false
        self.imageView.alpha = 1
    }
    
    func jumpBack5(fromValue: Float) {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .jumpBack5, value: fromValue)
    }
    func jumpForward5(fromValue: Float) {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .jumpForward5, value: fromValue)
    }
    
    func startSlider() {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .initialize)
    }
}
