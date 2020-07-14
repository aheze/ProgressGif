//
//  PhotoPageViewController+Player.swift
//  ProgressGif
//
//  Created by Zheng on 7/13/20.
//

import UIKit
import AVFoundation
import Photos

protocol UpdateSliderProgress: class {
    func updateSlider(to value: Float)
}
class PlayerView: UIView {
    
    weak var updateSliderProgress: UpdateSliderProgress?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerItemContext = 0

    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    
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
    
//    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
//        let asset = AVAsset(url: url)
//        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
//            var error: NSError? = nil
//            let status = asset.statusOfValue(forKey: "playable", error: &error)
//            switch status {
//            case .loaded:
//                completion?(asset)
//            case .failed:
//                print(".failed")
//            case .cancelled:
//                print(".cancelled")
//            default:
//                print("default")
//            }
//        }
//    }
    private func setUpPlayerItem(with asset: AVAsset) {
        print("setUpPlayerItem")
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
            
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
            
            let _ = self?.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] (time) in
                
                let newProgress = Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(asset.duration))
                
                if self?.player?.rate != 0 {
                    self?.updateSliderProgress?.updateSlider(to: Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(asset.duration)))
                    print("new progress: \(newProgress)")
                }
//                self?.audioPlayerSlider.value = Float(CMTimeGetSeconds(time)) / Float(asset.duration)
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
                print(".readyToPlay")
                player?.play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    func startPlay(with asset: PHAsset) {
//        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            if let avAssetU = avAsset as? AVURLAsset {
                self.setUpPlayerItem(with: avAssetU)
//                DispatchQueue.main.async {
//                    let player = AVPlayer(url: avAssetU.url)
//
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    self.present(playerViewController, animated: true) {
//                        playerViewController.player!.play()
//                    }
//                }
            }
        }
        
//        }
    }
    
    func play() {
        player?.play()
    }
    func pause() {
        player?.pause()
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        print("deinit of PlayerView")
    }
}

extension PhotoPageViewController {
    
}

extension PhotoPageViewController: PlayerControlsDelegate {
    func backPressed() {
        
    }
    
    func forwardPressed() {
        
    }
    
    func sliderChanged(value: Float, event: SliderEvent) {
//        currentViewController.playerView.pause()
        
        
        
        switch event {
        case .began:
            currentViewController.playerView.pause()
            
        case .moved:
            if let currentTimescale = currentViewController.playerView.player?.currentItem?.duration.timescale {
                let timeStamp = value / Float(currentViewController.asset.duration)
                print("slidervalue: \(value), totalDuration \(currentViewController.asset.duration)")
                
                
                let time = CMTimeMakeWithSeconds(Float64(timeStamp), preferredTimescale: currentTimescale)
                print("seeking, timeStamp: \(timeStamp), time: \(time)")
                currentViewController.playerView.player?.seek(to: time)
                { [weak self] (finished) in
                    print("play again")
                    
                    if finished {
                        self?.currentViewController.playerView.play()
                    }
                }
            }
            
        case .ended:
            print("ended!")
//            currentViewController.playerView.play()
        default:
            break
        }
    }
    
    func changedPlay(playingState: PlayingState) {
        if playingState == .playing {
            print("playing!! Play")
//            playVideo(asset: photoAssets.object(at: currentIndex))
            
            currentViewController.playVideo()
        } else {
            currentViewController.pauseVideo()
        }
    }
}
