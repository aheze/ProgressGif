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
    
    /// configuration of every edit. Used to render gif.
    var editingConfiguration = EditingConfiguration()
    
    var imageAspectRect = CGRect(x: 0, y: 0, width: 50, height: 50)
    
    var asset: PHAsset!
    var hasInitializedPlayer = false
    
    /// constraints for the video player and player controls view,
    /// because they are __not__ in the same view as the base view.
    /// these constraints will be calculated based on the heights of subviews in the base view.
    @IBOutlet weak var playerHolderTopC: NSLayoutConstraint!
    @IBOutlet weak var playerControlsBottomC: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        
        let statusHeight = topStatusBlurView.frame.height
        let topBarheight = topActionBarBlurView.frame.height
        let topBarToPreview = topBarAndPreviewVerticalC.constant
        let previewHeight = previewLabel.frame.height
        let previewToPlayerMargin = CGFloat(8)
        
        let topConstant = statusHeight + topBarheight + topBarToPreview + previewHeight + previewToPlayerMargin
        
        let bottomConstant = bottomReferenceView.frame.height
        
        playerHolderTopC.constant = topConstant
        playerControlsBottomC.constant = bottomConstant
        
        calculateAspectDrawingFrame()
    }
    
    @IBOutlet weak var topStatusBlurView: UIVisualEffectView!
    @IBOutlet weak var topActionBarBlurView: UIVisualEffectView!
    @IBOutlet weak var topBarAndPreviewVerticalC: NSLayoutConstraint!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var playerHolderView: UIView!
    
    /// round corners / drop shadow on this view
    /// contains `playerView` and `drawingView`
    @IBOutlet weak var playerBaseView: UIView!
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    // MARK: - Drawing
    
    /// progress bar
    
    /// fits right onto the aspect fit of the image, so that the progress bar appears that it is on the image.
    @IBOutlet weak var drawingView: UIView!
    
    @IBOutlet weak var drawingViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewRightC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTopC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewBottomC: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var progressBarBackgroundView: UIView!
    @IBOutlet weak var progressBarBackgroundHeightC: NSLayoutConstraint!
    
    var progressBarFullWidth: CGFloat {
        get {
            return progressBarBackgroundView.frame.width
        }
    }
    
    /// `progressBarView` is a subview of `progressBarBackgroundView`
    @IBOutlet weak var progressBarView: UIView!
    
    /// the width of the progress bar
    /// `equal widths` wouldn't work because `multiplier` is a read-only property
    @IBOutlet weak var progressBarWidthC: NSLayoutConstraint!
    
    /// back/forward/play/slider
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
    
    // MARK: - Editing Paging VCs
    @IBOutlet weak var bottomReferenceView: UIView!
    var editingBarVC: EditingBarVC?
    var editingEdgesVC: EditingEdgesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// first hide progress bar until transition finishes
        progressBarBackgroundHeightC.constant = 0
        progressBarWidthC.constant = 0
        
        
        playerControlsView.playerControlsDelegate = self
        playerView.updateSliderProgress = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        editingBarVC = storyboard.instantiateViewController(withIdentifier: "EditingBarVC") as? EditingBarVC
        editingBarVC?.title = "Bar"
        editingBarVC?.originalBarHeight = editingConfiguration.barHeight
        editingBarVC?.originalBarForegroundColor = editingConfiguration.barForegroundColor
        editingBarVC?.originalBarBackgroundColor = editingConfiguration.barBackgroundColor
        editingBarVC?.editingBarChanged = self
        
        editingEdgesVC = storyboard.instantiateViewController(withIdentifier: "EditingEdgesVC") as? EditingEdgesVC
        editingEdgesVC?.title = "Edges"
        editingEdgesVC?.originalEdgeInset = editingConfiguration.edgeInset
        editingEdgesVC?.originalEdgeCornerRadius = editingConfiguration.edgeCornerRadius
        editingEdgesVC?.originalEdgeShadowColor = editingConfiguration.edgeShadowColor
        editingEdgesVC?.editingEdgesChanged = self
        
        /// options will be added in a later release
//        let editingOptionsVC = storyboard.instantiateViewController(withIdentifier: "EditingOptionsVC") as! EditingOptionsVC
//        editingOptionsVC.title = "Options"

        guard let editingBarViewController = editingBarVC,
            let editingEdgesViewController = editingEdgesVC else {
                return
        }
        
        let pagingViewController = PagingViewController(viewControllers: [
          editingBarViewController,
          editingEdgesViewController,
//          editingOptionsVC
        ])

        pagingViewController.textColor = UIColor.label
        pagingViewController.selectedTextColor = UIColor(named: "YellorangeText") ?? UIColor.blue /// will look terrible but it won't happen
        
        pagingViewController.indicatorColor = UIColor(named: "Yellorange") ?? UIColor.blue
        pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
        pagingViewController.borderColor = UIColor.systemFill /// line at the bottom of the menu buttons
        
        pagingViewController.backgroundColor = UIColor.systemBackground
        pagingViewController.selectedBackgroundColor = UIColor.systemBackground
        
        self.add(childViewController: pagingViewController, inView: bottomReferenceView)
        
        
    }
    
}

