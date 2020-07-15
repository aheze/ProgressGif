//
//  PopAnimator.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.8
    var presenting = true
    var originFrame = CGRect.zero
    var playerOriginFrame = CGRect.zero
    var thumbnailImage = UIImage()
    var statusBarHeight = CGFloat(0)
    var sliderValue = Float(0)
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        let editingView = presenting ? toView : transitionContext.view(forKey: .from)!
        let editingVC = presenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)
        
        guard
            let editingViewController = editingVC as? EditingViewController,
            let editingBaseView = editingViewController.baseView,
            let editingTopStatusBlurView = editingViewController.topStatusBlurView,
            let editingPlayerControlsView = editingViewController.playerControlsView,
            let playerHolderView = editingViewController.playerHolderView,
            let imageView = editingViewController.imageView
        else {
            print("Failed to cast as EditingViewController")
            return
        }
       
        let editingPlayerviewFrame = playerHolderView.frame
        let initialFrame = presenting ? originFrame : editingPlayerviewFrame
        let finalFrame = presenting ? editingPlayerviewFrame : originFrame
        
        print("is presenting? \(presenting), initial frame: \(initialFrame), final frame: \(finalFrame)")
        
        let editingPlayerControlsViewFrame = editingPlayerControlsView.frame
        let initialPlayerControlsFrame = presenting ? playerOriginFrame : editingPlayerControlsViewFrame
        let finalPlayerControlsFrame = presenting ? editingPlayerControlsViewFrame : playerOriginFrame
        
        let initialEditingBaseViewY = presenting ? UIScreen.main.bounds.height + editingTopStatusBlurView.frame.height : 0
        let finalEditingBaseViewY = presenting ? 0 : UIScreen.main.bounds.height + editingTopStatusBlurView.frame.height
        
        
            
//            editingBaseView.frame.origin.y = UIScreen.main.bounds.height
//            editingTopStatusBlurView.frame.origin.y = editingBaseView.frame.origin.y - editingTopStatusBlurView.frame.height
            
            
            
            
        if presenting {
            imageView.frame = initialFrame
            
            editingPlayerControlsView.frame = initialPlayerControlsFrame
            
            imageView.image = thumbnailImage
            imageView.contentMode = .scaleAspectFit
            editingPlayerControlsView.customSlider.setValue(sliderValue, animated: false)
            
            editingBaseView.frame.origin.y = initialEditingBaseViewY
            editingTopStatusBlurView.frame.origin.y = initialEditingBaseViewY - editingTopStatusBlurView.frame.height
        } else {
            
        }
        
        
        
        
        
        containerView.addSubview(toView)
        if !self.presenting {
          self.dismissCompletion?()
        }
        
        containerView.bringSubviewToFront(editingView)

        UIView.animate(
          withDuration: duration,
          delay: 0.0,
          usingSpringWithDamping: 0.9,
          initialSpringVelocity: 0.2,
          animations: {
            
            if self.presenting {
                editingBaseView.frame.origin.y = finalEditingBaseViewY
                editingTopStatusBlurView.frame.origin.y = finalEditingBaseViewY - editingTopStatusBlurView.frame.height
                
                imageView.frame = finalFrame
                editingPlayerControlsView.frame = finalPlayerControlsFrame
            } else {
                editingViewController.view.frame.origin.y = UIScreen.main.bounds.height
            }
          }, completion: { _ in
            
            
            print("finished transition.")
            transitionContext.completeTransition(true)
        })
    }
    
    
}
