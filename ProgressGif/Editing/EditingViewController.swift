//
//  EditingViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit
import Photos

class EditingViewController: UIViewController {
    
    var asset: PHAsset!
    var hasInitializedPlayer = false
    
    
    @IBOutlet weak var topStatusBlurView: UIVisualEffectView!
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var playerHolderView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playerControlsView: PlayerControlsView!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBAction func galleryButtonPressed(_ sender: Any) {
        playerView.pause()
        playerView.player = nil
        hasInitializedPlayer = false
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func exportButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var bottomReferenceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerControlsView.playerControlsDelegate = self
        playerView.updateSliderProgress = self
    }
    
}



