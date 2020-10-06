//
//  PlayerView.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit
import AVFoundation
import Photos

protocol UpdateSliderProgress: class {
    func updateSlider(to value: Float)
    func finishedVideo()
}

// MARK: - The custom video player
/// Used for previewing videos (when importing from Photos) and while editing.
class PlayerView: UIView {
    
    enum PlayerContext {
        case none
        case jumpBack5
        case jumpForward5
        case initialize
        case playFromValue
    }
    
    var startValue = Float(-5)
    
    var failedPlaying: (() -> Void)?
    weak var updateSliderProgress: UpdateSliderProgress?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerItemContext = 0
    
    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    
    var playerContext = PlayerContext.none
    var playingState = PlayingState.paused
    var hasFinishedVideo = false
    var readyToPlay = false
    
    private var avAsset: AVAsset?
    var avURLAsset: AVURLAsset?
    
    /// the AVPlayer instance
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
            
            let _ = self?.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: DispatchQueue.main) { [weak self] (time) in
                let newProgress = Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(asset.duration))
                if self?.playingState == .playing {
                    self?.updateSliderProgress?.updateSlider(to: newProgress)
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                
                readyToPlay = true
                switch playerContext {
                case .none:
                    playingState = .playing
                    player?.play()
                case .jumpBack5:
                    playerContext = .none
                    if let videoDuration = avAsset?.duration {
                        
                        var finalSeconds = Double(0)
                        if startValue >= 0 {
                            let currentTime = startValue * Float(CMTimeGetSeconds(videoDuration))
                            finalSeconds = max(0, Double(currentTime - 5))
                            
                            if let currentTimescale = player?.currentItem?.duration.timescale {
                                let newCMTime = CMTimeMakeWithSeconds(finalSeconds, preferredTimescale: currentTimescale)
                                seekToTime(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30), completionHandler: { _ in })
                                
                                if playingState == .paused {
                                    let forwardSliderValue = Float(finalSeconds / CMTimeGetSeconds(videoDuration))
                                    self.updateSliderProgress?.updateSlider(to: forwardSliderValue)
                                }
                            }
                        }
                        
                    }
                case .jumpForward5:
                    playerContext = .none
                    if let videoDuration = avAsset?.duration {
                        
                        var finalSeconds = Double(0)
                        if startValue >= 0 {
                            let currentTime = startValue * Float(CMTimeGetSeconds(videoDuration))
                            finalSeconds = min(CMTimeGetSeconds(videoDuration), Double(currentTime + 5))
                        } else {
                            finalSeconds = min(CMTimeGetSeconds(videoDuration), 5)
                        }
                        
                        if finalSeconds == CMTimeGetSeconds(videoDuration) {
                            hasFinishedVideo = true
                            updateSliderProgress?.finishedVideo()
                        }
                        
                        if let currentTimescale = player?.currentItem?.duration.timescale {
                            let newCMTime = CMTimeMakeWithSeconds(finalSeconds, preferredTimescale: currentTimescale)
                            player?.seek(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30))
                            
                            if playingState == .paused {
                                let forwardSliderValue = Float(finalSeconds / CMTimeGetSeconds(videoDuration))
                                self.updateSliderProgress?.updateSlider(to: forwardSliderValue)
                                
                            }
                        }
                    }
                case .initialize:
                    playerContext = .none
                case .playFromValue:
                    playerContext = .none
                    
                    if let videoDuration = avAsset?.duration {
                        
                        if let currentTimescale = player?.currentItem?.duration.timescale {
                            let newTime = startValue * Float(CMTimeGetSeconds(videoDuration))
                            let newCMTime = CMTimeMakeWithSeconds(Float64(newTime), preferredTimescale: currentTimescale)
                            
                            if newCMTime == videoDuration {
                                hasFinishedVideo = true
                                updateSliderProgress?.finishedVideo()
                                play()
                                print("end")
                            } else {
                                print("seek, start value: \(startValue), CMTIme: \(newCMTime)")
                                seekToTime(to: newCMTime, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30), completionHandler: { _ in })
                                self.playingState = .playing
                                self.player?.play()
                            }
                        }
                    }
                }
                
            case .failed:
                print(".failed")
                failedToPlay()
            case .unknown:
                print(".unknown")
                failedToPlay()
            @unknown default:
                print("@unknown default")
                failedToPlay()
            }
        }
    }
    
    func seekToTime(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping ((Bool) -> Void)) {
        if readyToPlay {
            player?.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler)
        }
    }
    
    func failedToPlay() {
        failedPlaying?()
    }
    func startPlay(with asset: AVAsset, playerContext: PlayerContext = .none, value: Float = -5) {
        startValue = value
        self.playerContext = playerContext
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.avAsset = asset
        if let avAssetU = asset as? AVURLAsset {
            self.setUpPlayerItem(with: avAssetU)
            self.avURLAsset = avAssetU
            
        }
    }
    
    func play() {
        playingState = .playing
        
        if hasFinishedVideo {
            hasFinishedVideo = false
            seekToTime(to: CMTime.zero, toleranceBefore: CMTimeMake(value: 1, timescale: 30), toleranceAfter: CMTimeMake(value: 1, timescale: 30)) { [weak self](state) in
                self?.player?.play()
            }
        } else {
            player?.play()
        }
        
    }
    func pause(fromSlider: Bool = false) {
        if !fromSlider {
            /// if slider paused, that means it was temporary (pause so that seek can occur)
            playingState = .paused
        }
        player?.pause()
    }
    
    @objc func playerDidFinishPlaying(note: Notification) {
        pause()
        hasFinishedVideo = true
        updateSliderProgress?.finishedVideo()
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
}
