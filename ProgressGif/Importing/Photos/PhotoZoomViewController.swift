//
//  PhotoZoomViewController.swift
//  FluidPhoto
//
//  Created by Masamichi Ueta on 2016/12/23.
//  Copyright © 2016 Masmichi Ueta. All rights reserved.
//

import UIKit
import Photos

protocol PhotoZoomViewControllerDelegate: class {
    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController, scrollViewDidScroll scrollView: UIScrollView)
}

// MARK: - the video preview controller
class PhotoZoomViewController: UIViewController {
    
    var hasInitializedPlayer = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    weak var delegate: PhotoZoomViewControllerDelegate?
    
    var index: Int = 0
    var asset: PHAsset!
    var avAsset: AVAsset!
    
    var imageSize: CGSize = CGSize(width: 0, height: 0)
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale)
    }

    var doubleTapGestureRecognizer: UITapGestureRecognizer! /// double-tap to zoom in
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAssetU, _, _) in
            self.avAsset = avAssetU
        }
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: PHImageRequestOptions()) { (imageU, userInfo) -> Void in
            if let image = imageU {
                self.imageView.image = image
                self.image = image
            }
        }
        self.view.addGestureRecognizer(self.doubleTapGestureRecognizer)
    }
    
    func playVideo() {
        if !hasInitializedPlayer {
            hasInitializedPlayer = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.alpha = 0
            })
            playerView.startPlay(with: avAsset)
        } else {
            playerView.play()
        }
    }
    
    func pauseVideo() {
        playerView.pause()
    }
    func stopVideo() {
        playerView.pause()
        playerView.player = nil
        hasInitializedPlayer = false
        self.imageView.alpha = 1
    }
    func jumpForward5() {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: avAsset, playerContext: .jumpForward5)
    }
    
    func startSlider() {
        hasInitializedPlayer = true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        })
        playerView.startPlay(with: avAsset, playerContext: .initialize)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: self.baseView)
        var newZoomScale = self.scrollView.maximumZoomScale
        
        if self.scrollView.zoomScale >= newZoomScale || abs(self.scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = self.scrollView.minimumZoomScale
        }
        
        let width = self.scrollView.bounds.width / newZoomScale
        let height = self.scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
}

extension PhotoZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return baseView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }
}
