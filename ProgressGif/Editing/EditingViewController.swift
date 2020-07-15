//
//  EditingViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit

class EditingViewController: UIViewController {
    
    @IBOutlet weak var topStatusBlurView: UIVisualEffectView!
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var playerHolderView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playerControlsView: PlayerControlsView!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBAction func galleryButtonPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func exportButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var bottomReferenceView: UIView!
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
//        view.insetsLayoutMarginsFromSafeArea = false
//        view.inset
        
        
    }
    
}



