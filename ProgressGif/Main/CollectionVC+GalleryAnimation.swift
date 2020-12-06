//
//  CollectionVC+GalleryAnimation.swift
//  ProgressGif
//
//  Created by Zheng on 7/23/20.
//

import UIKit

// MARK: - Transition animation
extension CollectionViewController: UIViewControllerTransitioningDelegate {
    func setUpDismissCompletion() {
        transition.dismissCompletion = { [weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                self?.view.alpha = 1
            })
        }
    }
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = true
        
        var imageFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        
        let currentImageView = getImageViewFromCollectionViewCell(for: selectedIndexPath)
        
        if let contentFrame = getCellContentFrame() {
            let imageViewFrame = currentImageView.frame
            
            let finalFrame = CGRect(x: contentFrame.origin.x + imageViewFrame.origin.x,
                                    y: contentFrame.origin.y + imageViewFrame.origin.y - windowStatusBarHeight,
                                    width: imageViewFrame.width,
                                    height: imageViewFrame.height)
            imageFrame = finalFrame
        }
        
        transition.originFrame = imageFrame
        let controlsFrame = CGRect(x: 16, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 140)
        
        
        transition.playerOriginFrame = controlsFrame
        transition.sliderValue = Float(0.5)
        
        if let image = currentImageView.image {
            transition.thumbnailImage = image
        }
        
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
