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
//    var adjustedFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        let editingView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        guard
            let editingViewController = transitionContext.viewController(forKey: .to) as? EditingViewController,
//            let editingPlayerview = editingViewController.playerView,
            let editingBaseView = editingViewController.baseView,
            let editingTopStatusBlurView = editingViewController.topStatusBlurView,
            let editingPlayerControlsView = editingViewController.playerControlsView,
            let playerHolderView = editingViewController.playerHolderView,
            let imageView = editingViewController.imageView
        else {
            print("Failed to cast as EditingViewController")
            return
        }
       
//        editingViewController.automaticallyAdjustsScrollViewInsets = false
        editingViewController.view.insetsLayoutMarginsFromSafeArea = false
        
        
        let editingPlayerviewFrame = playerHolderView.frame
        
        let initialFrame = presenting ? originFrame : editingPlayerviewFrame
        let finalFrame = presenting ? editingPlayerviewFrame : originFrame
        
        
        let editingPlayerControlsViewFrame = editingPlayerControlsView.frame
        
        let initialPlayerControlsFrame = presenting ? playerOriginFrame : editingPlayerControlsViewFrame
        let finalPlayerControlsFrame = presenting ? editingPlayerControlsViewFrame : playerOriginFrame
        
        
        print("initial frame: \(initialFrame),\nfinal frame: \(finalFrame)")
        print("----\narea working with base view: \(editingBaseView),\n area working with TOVIEW: \(toView),\n area working with container view: \(containerView)")

//        let xScaleFactor = presenting ?
//          initialFrame.width / finalFrame.width :
//          finalFrame.width / initialFrame.width
//
////        let yScaleFactor = presenting ?
////          initialFrame.height / finalFrame.height :
////          finalFrame.height / initialFrame.height
//
//        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: xScaleFactor)
//
        if presenting {
            
            
            editingBaseView.frame.origin.y = UIScreen.main.bounds.height
            editingTopStatusBlurView.frame.origin.y = editingBaseView.frame.origin.y - editingTopStatusBlurView.frame.height
            
//            print("scale transform: \(scaleTransform)")
//            playerHolderView.transform = scaleTransform
            
//            playerHolderView.center = CGPoint(
//                x: initialFrame.midX,
//                y: initialFrame.midY)
            
//            imageView.center = CGPoint(
//                x: initialFrame.midX,
//                y: initialFrame.midY)
            
            imageView.frame = originFrame
            
            editingPlayerControlsView.frame = playerOriginFrame
            
//            print("mid: \(CGPoint(x: initialFrame.midX, y: initialFrame.midY))")
//            playerHolderView.clipsToBounds = true
            
//            editingViewController.imageView.image = thumbnailImage
            imageView.image = thumbnailImage
            imageView.contentMode = .scaleAspectFit
            
        }

//        editingPreviewView.layer.cornerRadius = presenting ? 20.0 : 0.0
//        editingPreviewView.layer.masksToBounds = true

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(editingView)

//        let statusBarHeight = editingViewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        print("animating, stat height: \(self.statusBarHeight)")
        UIView.animate(
          withDuration: duration,
          delay: 0.0,
          usingSpringWithDamping: 0.9,
          initialSpringVelocity: 0.2,
          animations: {
            
            editingBaseView.frame.origin.y = 0
            editingTopStatusBlurView.frame.origin.y = 0 - editingTopStatusBlurView.frame.height
            
//            playerHolderView.transform = self.presenting ? .identity : scaleTransform
//            playerHolderView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            
            imageView.frame = finalFrame
            editingPlayerControlsView.frame = finalPlayerControlsFrame
          }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    
}
