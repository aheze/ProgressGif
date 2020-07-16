//
//  EditingViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit
import Photos
import Parchment

class EditingViewController: UIViewController {
    
    var editingConfiguration = EditingConfiguration()
    
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let editingBarVC = storyboard.instantiateViewController(withIdentifier: "EditingBarVC") as! EditingBarVC
        editingBarVC.title = "Bar"
        editingBarVC.originalBarHeight = editingConfiguration.barHeight
        editingBarVC.originalBarForegroundColor = editingConfiguration.barForegroundColor
        editingBarVC.originalBarBackgroundColor = editingConfiguration.barBackgroundColor
        editingBarVC.editingBarChanged = self
        
        let editingEdgesVC = storyboard.instantiateViewController(withIdentifier: "EditingEdgesVC") as! EditingEdgesVC
        editingEdgesVC.title = "Edges"
        
        let editingOptionsVC = storyboard.instantiateViewController(withIdentifier: "EditingOptionsVC") as! EditingOptionsVC
        editingOptionsVC.title = "Options"

        let pagingViewController = PagingViewController(viewControllers: [
          editingBarVC,
          editingEdgesVC,
          editingOptionsVC
        ])

        pagingViewController.textColor = UIColor.label
        pagingViewController.selectedTextColor = UIColor(named: "YellorangeText") ?? UIColor.blue /// will look terrible but it won't happen
        
        pagingViewController.indicatorColor = UIColor(named: "Yellorange") ?? UIColor.blue
        pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        pagingViewController.borderColor = UIColor.clear
        
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        pagingViewController.backgroundColor = UIColor.systemBackground
        pagingViewController.selectedBackgroundColor = UIColor.systemBackground
        
        self.add(childViewController: pagingViewController, inView: bottomReferenceView)
        
        
    }
    
}

