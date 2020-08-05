//
//  EditingViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/14/20.
//

import UIKit
import Photos
import Parchment
import RealmSwift

class EditingViewController: UIViewController {
    
    var dismissing = false
    
    let realm = try! Realm()
    var project: Project?
    
    /// configuration of every edit. Used to render gif.
    var editingConfiguration = EditableEditingConfiguration()
    
    var onDoneBlock: ((Bool) -> Void)?
    
    /// used to place the shadow
    var imageAspectRect = CGRect(x: 0, y: 0, width: 50, height: 50)
    var shadowScale = CGFloat(1)
    
    /// is proportional to the height of the video.
    /// the values changed in the number stepper are multiplied by this.
    var unit: CGFloat {
        get {
            let largerSide = max(drawingView.frame.width, drawingView.frame.height)
            return largerSide / Constants.unitDivision
        }
    }
    
    // MARK: - Video
    var avAsset: AVAsset!
    var hasInitializedPlayer = false
    var actualVideoResolution: CGSize?
    
    // MARK: - Player Constraint Calculations
    
    /// constraints for the video player and player controls view,
    /// because they are __not__ in the same view as the base view.
    /// these constraints will be calculated based on the heights of subviews in the base view.
    @IBOutlet weak var playerHolderTopC: NSLayoutConstraint!
    @IBOutlet weak var playerControlsBottomC: NSLayoutConstraint!
    var statusHeight = CGFloat(0)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !dismissing {
            statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            topBarTopC.constant = statusHeight
            view.layoutIfNeeded()
            updateFrames(statusHeight: statusHeight)
        }
    }
    
    // MARK: - Size Classes
    
    @IBOutlet weak var holderHorizontalRightC: NSLayoutConstraint!
    @IBOutlet weak var playerControlsHorizontalRightC: NSLayoutConstraint!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("Change trait!!!")
        statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        topBarTopC.constant = statusHeight
        view.layoutIfNeeded()
        print("Change trait stat height: \(statusHeight)")
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
            print("HORIZONTAL size class, safe inset esge: \(view.safeAreaInsets.right)")
            
            holderHorizontalRightC.constant = (bottomReferenceView.frame.width - view.safeAreaInsets.right) + 16
            playerControlsHorizontalRightC.constant = (bottomReferenceView.frame.width - view.safeAreaInsets.right) + 16
        }
    }
    
    func updateFrames(statusHeight: CGFloat) {
        
        let topBarheight = topActionBarBlurView.frame.height
        let topBarToPreview = topBarAndPreviewVerticalC.constant
        let previewHeight = previewLabel.frame.height
        let previewToPlayerMargin = CGFloat(8)
        
        let topConstant = statusHeight + topBarheight + topBarToPreview + previewHeight + previewToPlayerMargin
        
        let bottomConstant = bottomReferenceView.frame.height
        
        playerHolderTopC.constant = topConstant
        playerControlsBottomC.constant = bottomConstant
        
        calculateAspectDrawingFrame()
        barHeightChanged(to: editingConfiguration.barHeight)
    }
  
    
//    @IBOutlet weak var topStatusBlurView: UIVisualEffectView!
    
    @IBOutlet weak var topBarTopC: NSLayoutConstraint!
    
    @IBOutlet weak var topActionBarBlurView: UIVisualEffectView!
    @IBOutlet weak var topBarAndPreviewVerticalC: NSLayoutConstraint!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    
     // MARK: - Player
    
    @IBOutlet weak var playerHolderView: UIView!
    
    /// round corners / drop shadow on this view
    /// contains `playerView` and `drawingView`
    @IBOutlet weak var playerBaseView: UIView!
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    /// back/forward/play/slider
    @IBOutlet weak var playerControlsView: PlayerControlsView!
    
    
//    @IBOutlet weak var EditingPreviewView: UIView!
    
    // MARK: - Drawing
    
    /// progress bar
    
    /// fits __right onto the aspect fit of the image__, so that the progress bar appears that it is on the image.
    @IBOutlet weak var drawingView: UIView!
    
    @IBOutlet weak var drawingViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewRightC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTopC: NSLayoutConstraint!
    @IBOutlet weak var drawingViewBottomC: NSLayoutConstraint!
    
    /// same for the transparent background view
    
    @IBOutlet weak var transparentBackgroundImageView: UIImageView!
    
    @IBOutlet weak var transparentBackgroundImageViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var transparentBackgroundImageViewRightC: NSLayoutConstraint!
    @IBOutlet weak var transparentBackgroundImageViewTopC: NSLayoutConstraint!
    @IBOutlet weak var transparentBackgroundImageViewBottomC: NSLayoutConstraint!
    
    /// same for the masking view (for corner radius), but no constraints this time.
    /// maskingView's frame is directly set to whatever the image's aspect rect is
    @IBOutlet weak var maskingView: UIView!
    
    /// same for the shadow view
    @IBOutlet weak var shadowView: ResizableShadowView!
    
    /// prevent the shadow from spilling
    @IBOutlet weak var shadowMaskingView: UIView!
    
    @IBOutlet weak var shadowMaskingViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var shadowMaskingViewRightC: NSLayoutConstraint!
    @IBOutlet weak var shadowMaskingViewTopC: NSLayoutConstraint!
    @IBOutlet weak var shadowMaskingViewBottomC: NSLayoutConstraint!
    
    
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
    
   // MARK: - Top Bar
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBAction func galleryButtonPressed(_ sender: Any) {
        
        saveConfig()
        
        playerView.pause()
        playerView.player = nil
        hasInitializedPlayer = false
        
        onDoneBlock?(true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func exportButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ExportViewController") as? ExportViewController {
            
            if let resolutionWidth = project?.metadata?.resolutionWidth {
                if let resolutionHeight = project?.metadata?.resolutionHeight {
                    
                    let largerSide = max(CGFloat(resolutionWidth), CGFloat(resolutionHeight))
                    viewController.unit = largerSide / Constants.unitDivision
                    
                }
            }
            
            viewController.renderingAsset = avAsset
            viewController.editingConfiguration = editingConfiguration
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Editing Paging VCs
    @IBOutlet weak var bottomReferenceView: UIView!
    var editingBarVC: EditingBarVC?
    var editingEdgesVC: EditingEdgesVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got asset: \(avAsset)")

//        bottomReferenceView.layer.maskedCorners = [.layerMinXMinYCorner]
//        bottomReferenceView.layer.cornerRadius = 0
//        bottomReferenceView.clipsToBounds = true
        
//        if view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .compact {
//            bottomReferenceView.layer.cornerRadius = 4
//        }
        
        transparentBackgroundImageView.alpha = 0
        shadowView.alpha = 0
        maskingView.isHidden = true
        
        titleTextField.delegate = self
        
        /// first hide progress bar until transition finishes
        progressBarBackgroundView.alpha = 0
        progressBarBackgroundHeightC.constant = 0
        progressBarWidthC.constant = 0
        
        playerControlsView.playerControlsDelegate = self
        playerView.updateSliderProgress = self
        
        setUpPagingViewControllers()
        
        if let projectMetadata = project?.metadata {
            actualVideoResolution = CGSize(width: projectMetadata.resolutionWidth, height: projectMetadata.resolutionHeight)
        }
        
        print("view did load")
    }
}

