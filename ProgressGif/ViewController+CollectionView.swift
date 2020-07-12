//
//  ViewController+CollectionView.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

//extension ViewController {
//    
//    func add(asChildViewController viewController: UIViewController) {
//        // Add Child View Controller
//        addChild(viewController)
//
//        // Add Child View as Subview
//        view.insertSubview(viewController.view, at: 0)
//
//        // Configure Child View
//        viewController.view.frame = view.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        print("adding view controller")
//        // Notify Child View Controller
//        viewController.didMove(toParent: self)
//    }
//    
//}

extension UIViewController {
    func add(childViewController: UIViewController, inView: UIView) {
        // Add Child View Controller
        addChild(childViewController)

        // Add Child View as Subview
        inView.insertSubview(childViewController.view, at: 0)

        // Configure Child View
        childViewController.view.frame = self.view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        print("adding view controller")
        // Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
}
