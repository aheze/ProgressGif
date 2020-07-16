//
//  PhotoCell.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String!
    var realFrameRect: CGRect!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBaseView: ShadowView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
}
