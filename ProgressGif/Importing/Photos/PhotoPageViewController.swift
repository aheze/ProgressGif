//
//  PhotoPageViewController.swift
//  FluidPhoto
//
//  Created by Masamichi Ueta on 2016/12/23.
//  Copyright © 2016 Masmichi Ueta. All rights reserved.
//

import UIKit
import Photos
import RealmSwift


protocol PhotoPageViewControllerDelegate: class {
    func containerViewController(_ containerViewController: PhotoPageViewController, indexDidUpdate currentIndex: Int)
}

class PhotoPageViewController: UIViewController, UIGestureRecognizerDelegate {

    let realm = try! Realm()
    
    var onDoneBlock: ((Bool) -> Void)?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var normalStatusBarHeight = CGFloat(0)
    
    let transition = PopAnimator()
    
    @IBOutlet weak var backBlurView: UIVisualEffectView!
    @IBOutlet weak var chooseBlurView: UIVisualEffectView!
    
    @IBOutlet weak var backBaseView: UIView!
    @IBOutlet weak var chooseBaseView: UIView!
    @IBOutlet weak var playerControlsView: PlayerControlsView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.currentViewController.scrollView.isScrollEnabled = false
        self.transitionController.isInteractive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBAction func chooseButtonPressed(_ sender: Any) {
        
        let newProject = Project()
        newProject.title = "Untitled"
        newProject.dateCreated = Date()
        
        let defaults = UserDefaults.standard
        
        let barHeight = defaults.value(forKey: DefaultKeys.barHeight) as? Int ?? 5
        let barForegroundColorHex = defaults.value(forKey: DefaultKeys.barForegroundColorHex) as? String ?? "FFB500"
        let barBackgroundColorHex = defaults.value(forKey: DefaultKeys.barBackgroundColorHex) as? String ?? "F4F4F4"
        
        let edgeInset = defaults.value(forKey: DefaultKeys.edgeInset) as? Int ?? 0
        let edgeCornerRadius = defaults.value(forKey: DefaultKeys.edgeCornerRadius) as? Int ?? 0
        let edgeShadowIntensity = defaults.value(forKey: DefaultKeys.edgeShadowIntensity) as? Int ?? 0
        let edgeShadowRadius = defaults.value(forKey: DefaultKeys.edgeShadowRadius) as? Int ?? 0
        let edgeShadowColorHex = defaults.value(forKey: DefaultKeys.edgeShadowColorHex) as? String ?? "000000"
        
        
        let configuration = EditingConfiguration()
        configuration.barHeight = barHeight
        configuration.barForegroundColorHex = barForegroundColorHex
        configuration.barBackgroundColorHex = barBackgroundColorHex
        
        configuration.edgeInset = edgeInset
        configuration.edgeCornerRadius = edgeCornerRadius
        configuration.edgeShadowIntensity = edgeShadowIntensity
        configuration.edgeShadowRadius = edgeShadowRadius
        configuration.edgeShadowColorHex = edgeShadowColorHex
        
        newProject.configuration = configuration
        
        let metadata = VideoMetadata()
        newProject.metadata = metadata
        
        PHCachingImageManager().requestAVAsset(forVideo: currentViewController.asset, options: nil) { (avAsset, _, _) in
            
            if let videoResolution = avAsset?.resolutionSize() {
                metadata.resolutionWidth = Int(videoResolution.width)
                metadata.resolutionHeight = Int(videoResolution.height)
            }
            
            if let cmDuration = avAsset?.duration {
                let duration = CMTimeGetSeconds(cmDuration)
                metadata.duration = duration.getFormattedString() ?? "0:01"
            }
            
            DispatchQueue.main.async {
                metadata.localIdentifier = self.currentViewController.asset.localIdentifier
                do {
                    try self.realm.write {
                        self.realm.add(newProject)
                    }
                } catch {
                    print("error adding object: \(error)")
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController {
                    viewController.transitioningDelegate = self
                    viewController.avAsset = avAsset
                    viewController.project = newProject
                    viewController.onDoneBlock = self.onDoneBlock
                    viewController.statusHeight = self.normalStatusBarHeight
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var backBlurTopC: NSLayoutConstraint!
    @IBOutlet weak var chooseBlurTopC: NSLayoutConstraint!
    @IBOutlet weak var playerBlurBottomC: NSLayoutConstraint!
    
    enum ScreenMode {
        case full, normal
    }
    
    var currentMode: ScreenMode = .normal
    
    weak var delegate: PhotoPageViewControllerDelegate?
    
    var pageViewController: UIPageViewController {
        return self.children[0] as! UIPageViewController
    }
    
    var currentViewController: PhotoZoomViewController {
        return self.pageViewController.viewControllers![0] as! PhotoZoomViewController
    }
    var previousViewController: PhotoZoomViewController?
    
    var photoAssets: PHFetchResult<PHAsset>!
    var currentIndex = 0
    var nextIndex: Int?
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    var transitionController = ZoomTransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDismissCompletion()
        
        playerControlsView.playerControlsDelegate = self
        
        backBaseView.clipsToBounds = false
        chooseBaseView.clipsToBounds = false
        playerControlsView.clipsToBounds = false
        
        backBaseView.alpha = 0
        chooseBaseView.alpha = 0
        playerControlsView.alpha = 0
        
        backBlurView.clipsToBounds = true
        chooseBlurView.clipsToBounds = true
        
        backBlurView.layer.cornerRadius = 10
        chooseBlurView.layer.cornerRadius = 10
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        self.pageViewController.view.addGestureRecognizer(self.panGestureRecognizer)
        
        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        self.pageViewController.view.addGestureRecognizer(self.singleTapGestureRecognizer)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(PhotoZoomViewController.self)") as! PhotoZoomViewController
        vc.delegate = self
        vc.index = self.currentIndex
        
        vc.asset = photoAssets.object(at: currentIndex)
        
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
        let viewControllers = [
            vc
        ]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        previousViewController = currentViewController
        currentViewController.playerView.updateSliderProgress = self
    }
    
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: self.view)
            
            var velocityCheck : Bool = false
            
            if UIDevice.current.orientation.isLandscape {
                velocityCheck = velocity.x < 0
            }
            else {
                velocityCheck = velocity.y < 0
            }
            if velocityCheck {
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if otherGestureRecognizer == self.currentViewController.scrollView.panGestureRecognizer {
            if self.currentViewController.scrollView.contentOffset.y == 0 {
                return true
            }
        }
        
        return false
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.currentViewController.scrollView.isScrollEnabled = false
            self.transitionController.isInteractive = true
            self.dismiss(animated: true, completion: nil)
        case .ended:
            if self.transitionController.isInteractive {
                self.currentViewController.scrollView.isScrollEnabled = true
                self.transitionController.isInteractive = false
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if self.transitionController.isInteractive {
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }
    
    @objc func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        if self.currentMode == .full {
            changeScreenMode(to: .normal)
            self.currentMode = .normal
        } else {
            changeScreenMode(to: .full)
            self.currentMode = .full
        }

    }
    
    func changeScreenMode(to: ScreenMode) {
        if to == .full {
            slideControlsOut()
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self.view.backgroundColor = .black
                            
            }, completion: { completed in
            })
        } else {
            slideControlsIn()
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            UIView.animate(withDuration: 0.25,
                           animations: {
                            if #available(iOS 13.0, *) {
                                self.view.backgroundColor = .systemBackground
                            } else {
                                self.view.backgroundColor = .white
                            }
            }, completion: { completed in
            })
        }
    }
}

extension PhotoPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == 0 {
            return nil
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(PhotoZoomViewController.self)") as! PhotoZoomViewController
        vc.delegate = self
        
        vc.asset = photoAssets.object(at: currentIndex - 1)
//        vc.url = self.photoAssets[currentIndex - 1]
        vc.index = currentIndex - 1
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == (self.photoAssets.count - 1) {
            return nil
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(PhotoZoomViewController.self)") as! PhotoZoomViewController
        vc.delegate = self
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
//        vc.url = self.photoAssets[currentIndex + 1]
        
        vc.asset = photoAssets.object(at: currentIndex + 1)
        vc.index = currentIndex + 1
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else {
            return
        }
        
        self.nextIndex = nextVC.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed && self.nextIndex != nil) {
            previousViewControllers.forEach { vc in
                let zoomVC = vc as! PhotoZoomViewController
                zoomVC.scrollView.zoomScale = zoomVC.scrollView.minimumZoomScale
            }
            
            playerControlsView.stop()
            previousViewController?.stopVideo()
            playerControlsView.backToBeginning()
            
            self.currentIndex = self.nextIndex!
            self.delegate?.containerViewController(self, indexDidUpdate: self.currentIndex)
            
            previousViewController = currentViewController
            currentViewController.playerView.updateSliderProgress = self
        }
        
        self.nextIndex = nil
    }
    
}

extension PhotoPageViewController: PhotoZoomViewControllerDelegate {
    
    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController, scrollViewDidScroll scrollView: UIScrollView) {
        if scrollView.zoomScale != scrollView.minimumZoomScale && self.currentMode != .full {
            self.changeScreenMode(to: .full)
            self.currentMode = .full
        }
    }
}

extension PhotoPageViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        if zoomAnimator.isPresenting == false {
            slideControlsOut()
        }
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        if zoomAnimator.isPresenting == true && zoomAnimator.finishedDismissing == false {
            slideControlsIn()
        } else if zoomAnimator.isPresenting == false && zoomAnimator.finishedDismissing == false {
            slideControlsIn()
        }
        
        if zoomAnimator.isPresenting == false && zoomAnimator.finishedDismissing == true {
            print("Dismissing, dealloc.")
            currentViewController.playerView.pause()
            currentViewController.playerView.player = nil
        }
    }
    
    func slideControlsOut() {
        backBlurTopC.constant = -16
        chooseBlurTopC.constant = -16
        playerBlurBottomC.constant = -16
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.backBaseView.alpha = 0
            self.chooseBaseView.alpha = 0
            self.playerControlsView.alpha = 0
        }, completion: nil)
    }
    func slideControlsIn() {
        backBlurTopC.constant = 16
        chooseBlurTopC.constant = 16
        playerBlurBottomC.constant = 16
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.backBaseView.alpha = 1
            self.chooseBaseView.alpha = 1
            self.playerControlsView.alpha = 1
        }, completion: nil)
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return self.currentViewController.imageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {        
        return self.currentViewController.scrollView.convert(self.currentViewController.imageView.frame, to: self.currentViewController.view)
    }
}
