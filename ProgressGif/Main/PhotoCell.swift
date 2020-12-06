//
//  PhotoCell.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

// MARK: - the cell used for displaying projects/video thumbnails
class PhotoCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String!
    var realFrameRect: CGRect!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBaseView: ShadowView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var drawingView: UIView!
    
    @IBOutlet weak var drawingLeftC: NSLayoutConstraint!
    @IBOutlet weak var drawingRightC: NSLayoutConstraint!
    @IBOutlet weak var drawingTopC: NSLayoutConstraint!
    @IBOutlet weak var drawingBottomC: NSLayoutConstraint!
    
    
}
