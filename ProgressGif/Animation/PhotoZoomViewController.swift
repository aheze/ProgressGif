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

class PhotoZoomViewController: UIViewController {
    
//    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: PhotoZoomViewControllerDelegate?
//
//    var image: UIImage!
    var index: Int = 0
//    var url: URL?
    var asset: PHAsset!
    var imageSize: CGSize = CGSize(width: 0, height: 0)
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale)
    }

    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
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
//        self.imageView.image = self.image
//        self.imageView.sd_setImage(with: url)
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: PHImageRequestOptions()) { (image, userInfo) -> Void in
            if let image = image {
//                if userInfo?[PHImageResultIsDegradedKey] as? NSNumber == true {
//                    print("is degraded!")
//                } else {
//                    print("is not degraded!")
//
                    
                    self.imageView.image = image
                    let rectFrame = CGRect(x: self.imageView.frame.origin.x,
                    y: self.imageView.frame.origin.y,
                    width: self.targetSize.width,
                    height: self.targetSize.width)
                    
                    print("rectFrame: \(rectFrame)")
                    self.imageView.frame = rectFrame
                    
//                    self.updateZoomScaleForSize(self.view.bounds.size)
//                    self.updateConstraintsForSize(self.view.bounds.size)
//                }
//
            }
        }
        
        
        self.view.addGestureRecognizer(self.doubleTapGestureRecognizer)        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateZoomScaleForSize(view.bounds.size)
//        updateConstraintsForSize(view.bounds.size)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateZoomScaleForSize(view.bounds.size)
//        updateConstraintsForSize(view.bounds.size)
//    }
//
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: self.imageView)
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
    
//    fileprivate func updateZoomScaleForSize(_ size: CGSize) {
//        print("image bounds: \(imageView.bounds)")
//        let widthScale = size.width / imageView.bounds.width
//        let heightScale = size.height / imageView.bounds.height
//        let minScale = min(widthScale, heightScale)
//        scrollView.minimumZoomScale = minScale
//
//        scrollView.zoomScale = minScale
//        scrollView.maximumZoomScale = minScale * 4
//    }
//
//    fileprivate func updateConstraintsForSize(_ size: CGSize) {
//        print("image bounds constraints: \(imageView.bounds)")
//        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
//        imageViewTopConstraint.constant = yOffset
//        imageViewBottomConstraint.constant = yOffset
//
//        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
//        imageViewLeadingConstraint.constant = xOffset
//        imageViewTrailingConstraint.constant = xOffset
//
//        let contentHeight = yOffset * 2 + self.imageView.frame.height
//        view.layoutIfNeeded()
//        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: contentHeight)
//    }
}

extension PhotoZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        updateConstraintsForSize(self.view.bounds.size)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }
}
