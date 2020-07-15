//
//  PhotoPageViewController+EditingAnimation.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit
import AVFoundation

extension PhotoPageViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            transition.presenting = true
            
            if let generatedImage = generateImage() {
                transition.thumbnailImage = generatedImage
            }
            
            if let aspectImageFrame = currentViewController.imageView.getAspectFitRect() {
                let biggerOverOriginal = (aspectImageFrame.height + normalStatusBarHeight) / aspectImageFrame.height
                print("bigger over: \(biggerOverOriginal)")
                
                let newWidth = aspectImageFrame.width * biggerOverOriginal
                let offsetEdgeHalf = (newWidth - aspectImageFrame.width) / 2
                
                /// adjusted bigger to make up for the status bar
                let adjustedStatusFrame = CGRect(x: aspectImageFrame.origin.x - offsetEdgeHalf,
                                                 y: aspectImageFrame.origin.y - normalStatusBarHeight,
                                                 width: newWidth,
                                                 height: aspectImageFrame.height * biggerOverOriginal)
                
                print("original frame: \(aspectImageFrame), adjusted frame: \(adjustedStatusFrame)")
                
                if adjustedStatusFrame.width >= adjustedStatusFrame.height {
                    /// fatter image
                    
                    let topMinus = (adjustedStatusFrame.width - adjustedStatusFrame.height) / 2
                    
                    let adjustedImageFrame = CGRect(x: adjustedStatusFrame.origin.x, y: adjustedStatusFrame.origin.y - topMinus, width: adjustedStatusFrame.width, height: adjustedStatusFrame.width)
                    transition.originFrame = adjustedImageFrame
                } else {
                    
                    let leftMinus = (adjustedStatusFrame.height - adjustedStatusFrame.width) / 2
                    let adjustedImageFrame = CGRect(x: adjustedStatusFrame.origin.x - leftMinus, y: adjustedStatusFrame.origin.y, width: adjustedStatusFrame.height, height: adjustedStatusFrame.height)
                    
                    transition.originFrame = adjustedImageFrame
                }
            }
            
            transition.playerOriginFrame = playerControlsView.frame
            
            print("status bar height: \(normalStatusBarHeight)")
            transition.statusBarHeight = normalStatusBarHeight
            
            UIView.animate(withDuration: 0.2, animations: {
                self.currentViewController.imageView.alpha = 0
                self.playerControlsView.alpha = 0
            }) { _ in
                self.currentViewController.imageView.isHidden = true
                self.playerControlsView.isHidden = true
            }
            
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return nil
    }
    
}

extension PhotoPageViewController {
    func generateImage() -> UIImage? {
        if currentViewController.hasInitializedPlayer {
            
            if let avAssetURL = currentViewController.playerView.avURLAsset {
                let asset = AVAsset(url: avAssetURL.url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                if let time = currentViewController.playerView.player?.currentTime() {
                    do {
                        let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                        let thumbnail = UIImage(cgImage: imageRef)
                        
                        return thumbnail
                    } catch {
                        print("error copying image")
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            //            return asset
            if let thumbnailImage = currentViewController.image {
                return thumbnailImage
            } else {
                return nil
            }
        }
        
    }
}
