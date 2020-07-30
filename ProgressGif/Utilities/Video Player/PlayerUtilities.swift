//
//  PlayerUtilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/13/20.
//

import UIKit
import AVFoundation
import AVKit
import Photos

//extension PhotoPageViewController {
//    func playVideo(asset: PHAsset) {
//        
//        guard (asset.mediaType == PHAssetMediaType.video)
//            
//            else {
//                print("Not a valid video media type")
//                return
//        }
//        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
//            if let avAssetU = avAsset as? AVURLAsset {
//                DispatchQueue.main.async {
//                    let player = AVPlayer(url: avAssetU.url)
//                    
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    self.present(playerViewController, animated: true) {
//                        playerViewController.player!.play()
//                    }
//                }
//            }
//        }
////        PHCachingImageManager.
////        PHCachingImageManager().requestAVAssetForVideo(asset, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [NSObject : AnyObject]?) in
////
////            let asset = asset as! AVURLAsset
////
////            dispatch_async(dispatch_get_main_queue(), {
////
////                let player = AVPlayer(URL: asset.URL)
////                let playerViewController = AVPlayerViewController()
////                playerViewController.player = player
////                view.presentViewController(playerViewController, animated: true) {
////                    playerViewController.player!.play()
////                }
////            })
////        })
////        PHCachingImageManager().re
//    }
//}
