//
//  PhotoPageViewController+EditingAnimation.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit
import AVFoundation

extension PhotoPageViewController: UIViewControllerTransitioningDelegate {
    func setUpDismissCompletion() {
        transition.dismissCompletion = { [weak self] in
            self?.currentViewController.imageView.isHidden = false
            self?.playerControlsView.isHidden = false
            self?.backBaseView.isHidden = false
            self?.chooseBaseView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                if !(self?.currentViewController.hasInitializedPlayer ?? true) {
                    self?.currentViewController.imageView.alpha = 1
                }
                self?.playerControlsView.alpha = 1
                self?.backBaseView.alpha = 1
                self?.chooseBaseView.alpha = 1
            })
        }
        
    }
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            if playerControlsView.customSlider.value > 0 {
                print("over 0")
                let generatedImage = generateImageFromCurrentPlayer()
                if let image = generatedImage {
                    self.transition.thumbnailImage = image
                }
                
            } else {
                print("not over 0")
                if let currentImage = currentViewController.image {
                    transition.thumbnailImage = currentImage
                }
            }
            
            let aspectImageFrame = currentViewController.imageView.getAspectFitRect() ?? CGRect(x: 0, y: 0, width: 100, height: 100)
            
            print("asp frame: \(aspectImageFrame)")
            let biggerOverOriginal = (aspectImageFrame.height + normalStatusBarHeight) / aspectImageFrame.height
            
            let newWidth = aspectImageFrame.width * biggerOverOriginal
            let offsetEdgeHalf = (newWidth - aspectImageFrame.width) / 2
            
            /// adjusted bigger to make up for the status bar
            let adjustedStatusFrame = CGRect(x: aspectImageFrame.origin.x - offsetEdgeHalf,
                                             y: aspectImageFrame.origin.y - normalStatusBarHeight,
                                             width: newWidth,
                                             height: aspectImageFrame.height * biggerOverOriginal)
            
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
            
            transition.presenting = true
            transition.playerOriginFrame = playerControlsView.frame
            transition.sliderValue = playerControlsView.customSlider.value
            
            playerControlsView.playingState = .paused
            playerControlsView.playButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            
            currentViewController.stopVideo()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.currentViewController.imageView.alpha = 0
                self.playerControlsView.alpha = 0
                self.backBaseView.alpha = 0
                self.chooseBaseView.alpha = 0
            }) { _ in
                self.currentViewController.imageView.isHidden = true
                self.playerControlsView.isHidden = true
                self.backBaseView.isHidden = true
                self.chooseBaseView.isHidden = true
            }
            
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
    }
    
}

extension PhotoPageViewController {
    func generateImageFromCurrentPlayer() -> UIImage? {
        if currentViewController.hasInitializedPlayer {
            if let avAssetURL = currentViewController.playerView.avURLAsset {
                if let time = currentViewController.playerView.player?.currentTime() {
                    let image = avAssetURL.url.generateImageAsync(atTime: time)
                    return image
                }
            }
        } else {
            //            return asset
            if let thumbnailImage = currentViewController.image {
                //                return thumbnailImage
                return thumbnailImage
            } else {
                return nil
            }
        }
        return nil
    }
}


