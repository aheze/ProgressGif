
  
//
//  PopAnimator.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//
import UIKit

//class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//
//    let duration = 0.8
//    var presenting = true
//    var originFrame = CGRect.zero
//    var playerOriginFrame = CGRect.zero
//    var thumbnailImage = UIImage()
//    var statusBarHeight = CGFloat(0)
//    var sliderValue = Float(0)
//
//    var dismissCompletion: (() -> Void)?
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//
//        let containerView = transitionContext.containerView
//        let toView = transitionContext.view(forKey: .to)!
//
//        let editingView = presenting ? toView : transitionContext.view(forKey: .from)!
//        let editingVC = presenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)
//
//        guard
//            let editingViewController = editingVC as? EditingViewController,
//            let editingBaseView = editingViewController.baseView,
//            let editingPlayerControlsView = editingViewController.playerControlsView,
//            let playerHolderView = editingViewController.playerHolderView,
//            let imageView = editingViewController.imageView
//            else {
//                print("Failed to cast as EditingViewController")
//                return
//        }
//
//        let editingPlayerviewFrame = playerHolderView.frame
//        let finalFrame = presenting ? editingPlayerviewFrame : originFrame
//
//        let editingPlayerControlsViewFrame = editingPlayerControlsView.frame
//        let finalPlayerControlsFrame = presenting ? editingPlayerControlsViewFrame : playerOriginFrame
//
//        if presenting {
//
//            print("origin: \(originFrame)")
//            editingBaseView.frame.origin.y = UIScreen.main.bounds.height
//            imageView.frame = originFrame
//
//            editingPlayerControlsView.frame = playerOriginFrame
//            editingPlayerControlsView.customSlider.setValue(sliderValue, animated: false)
//
//            imageView.image = thumbnailImage
//            imageView.contentMode = .scaleAspectFit
//
//        }
//
//        containerView.addSubview(toView)
//        containerView.bringSubviewToFront(editingView)
//
//        if !self.presenting {
//            self.dismissCompletion?()
//        }
////        print("frame frame: : \(editingBaseView.frame)")
//        UIView.animate(
//            withDuration: duration,
//            delay: 0.0,
//            usingSpringWithDamping: 0.9,
//            initialSpringVelocity: 0.2,
//            animations: {
//                if self.presenting {
////                    print("frame: \(editingBaseView.frame)")
//                    editingBaseView.frame.origin.y = 0
//                    imageView.frame = finalFrame
//                    editingPlayerControlsView.frame = finalPlayerControlsFrame
//                } else {
//                    editingView.frame.origin.y = UIScreen.main.bounds.height
//                }
//        }, completion: { _ in
//            editingViewController.setUpDrawing(with: editingViewController.editingConfiguration)
//            transitionContext.completeTransition(true)
//        })
//    }
//}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.8
    var presenting = true
    var originFrame = CGRect.zero
    var playerOriginFrame = CGRect.zero
    var thumbnailImage = UIImage()
    var sliderValue = Float(0)

    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
//        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!

//        let galleryView = presenting ? fromView : toView
        let editingView = presenting ? toView : transitionContext.view(forKey: .from)!
        let editingVC = presenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)

        guard
            let editingViewController = editingVC as? EditingViewController,
            let editingBaseView = editingViewController.baseView,
            let editingPlayerControlsView = editingViewController.playerControlsView,
            let playerHolderView = editingViewController.playerHolderView,
            let imageView = editingViewController.imageView
            else {
                print("Failed to cast as EditingViewController")
                return
        }

        let editingPlayerviewFrame = playerHolderView.frame
        let finalFrame = presenting ? editingPlayerviewFrame : originFrame

        let editingPlayerControlsViewFrame = editingPlayerControlsView.frame
        let finalPlayerControlsFrame = presenting ? editingPlayerControlsViewFrame : playerOriginFrame

        if presenting {

            print("origin: \(originFrame)")
            editingBaseView.frame.origin.y = UIScreen.main.bounds.height
            imageView.frame = originFrame

            editingPlayerControlsView.frame = playerOriginFrame
            editingPlayerControlsView.customSlider.setValue(sliderValue, animated: false)

            imageView.image = thumbnailImage
            imageView.contentMode = .scaleAspectFit

        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(editingView)

        if !self.presenting {
            self.dismissCompletion?()
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            animations: {
                if self.presenting {
                    editingBaseView.frame.origin.y = 0
                    imageView.frame = finalFrame
                    editingPlayerControlsView.frame = finalPlayerControlsFrame
                } else {
                    editingView.frame.origin.y = UIScreen.main.bounds.height
                }
        }, completion: { _ in
            DispatchQueue.main.async {
                editingViewController.setUpDrawing(with: editingViewController.editingConfiguration)
            }
            
            transitionContext.completeTransition(true)
        })
    }
}

