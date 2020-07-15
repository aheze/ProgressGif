//
//  EditingViewController+PlayerView.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

extension EditingViewController {
    func playVideo() {
        if !hasInitializedPlayer {
            hasInitializedPlayer = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.alpha = 0
            })
            playerView.startPlay(with: asset)
        } else {
            playerView.play()
        }
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
    func jumpForward5() {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .jumpForward5)
    }
    
    func startSlider() {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: asset, playerContext: .initialize)
    }
}
