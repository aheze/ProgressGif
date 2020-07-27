//
//  CollectionVC+GalleryAnimation.swift
//  ProgressGif
//
//  Created by Zheng on 7/23/20.
//

import UIKit

extension CollectionViewController: UIViewControllerTransitioningDelegate {
    func setUpDismissCompletion() {
        
        
        transition.dismissCompletion = { [weak self] in
//
            UIView.animate(withDuration: 0.2, animations: {
                self?.view.alpha = 1
            })
//            if let selectedInd = self?.selectedIndexPath {
//                let currentImage = self?.getImageViewFromCollectionViewCell(for: selectedInd)
//
//                currentImage?.isHidden = false
//
//
//                UIView.animate(withDuration: 0.2, animations: {
//                    currentImage?.alpha = 1
//                })
//            }
        }
        
    }
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            transition.presenting = true
            
            let currentImageView = getImageViewFromCollectionViewCell(for: selectedIndexPath)
            var baseCurrentImageFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
            if let realBaseImageFrame = getImageViewFrame() {
                baseCurrentImageFrame = realBaseImageFrame
            }
            
            transition.originFrame = baseCurrentImageFrame
            
            print("base frame: \(baseCurrentImageFrame)")
            
            let controlsFrame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 140)
            
            
            transition.playerOriginFrame = controlsFrame
            transition.statusBarHeight = windowStatusBarHeight
            transition.sliderValue = Float(0.5)
            
            if let image = currentImageView.image {
                transition.thumbnailImage = image
            }
            
//            transition.presentationOrigin = .gallery
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.alpha = 0
            })
            
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
    }
    
}
