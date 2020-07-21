//
//  FromPhotos.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import MobileCoreServices
import Photos

//MARK:- Image Picker

class FromPhotosPicker: UIViewController {
    
    var onDoneBlock: ((Bool) -> Void)?
    
    var windowStatusBarHeight = CGFloat(0)
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var videosLabel: UILabel!
    
    private lazy var collectionViewController: CollectionViewController? = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.inset = CGFloat(4)
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .photos
            viewController.onDoneBlock = onDoneBlock
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosLabel.alpha = 0.7
        rightArrowImageView.alpha = 0.7
        
        _ = collectionViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        windowStatusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        collectionViewController?.windowStatusBarHeight = self.windowStatusBarHeight
        
    }
}

