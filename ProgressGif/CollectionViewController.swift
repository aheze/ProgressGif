//
//  CollectionViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/11/20.
//

import UIKit
import Photos

enum CollectionType {
    case projects
    case photos
    
}
class CollectionViewController: UIViewController {
    
    
    var collectionType = CollectionType.projects
    var projects = [Project]()
    var photoAssets: PHFetchResult<PHAsset>!
    
    var cellSize = CGSize(width: 100, height: 100)
    
    var topInset = CGFloat(80)
    
    let inset = CGFloat(16)
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: inset + topInset, left: inset, bottom: inset, right: inset)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        print("setup collecitonview")
        
        if collectionType == .projects {
            
        } else {
            print("get assets!")
            getAssetFromPhoto()
        }
        
    }
    
    
    // get all videos from Photos library you need to import Photos framework
    // user photos array in collectionView for disaplying video thumnail
    func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        photoAssets = PHAsset.fetchAssets(with: options)
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    
}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionType == .projects {
            return projects.count
        } else {
            return photoAssets.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionType == .photos {
            if let photoCell = cell as? PhotoCell {
                photoCell.layoutIfNeeded()
                photoCell.contentView.layer.masksToBounds = true
                if let drawingRect = photoCell.imageView.roundCornersForAspectFit(radius: 6) {
                    photoCell.imageBaseView.shouldActivate = true
                    photoCell.imageBaseView.updateShadow(rect: drawingRect, radius: 6)
                }
                
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCellId", for: indexPath) as! PhotoCell
        
        if collectionType == .projects {
            cell.contentView.layer.cornerRadius = 6
            return cell
        } else {
            cell.contentView.backgroundColor = UIColor.clear
            let asset = photoAssets.object(at: indexPath.row)
            
            
            cell.representedAssetIdentifier = asset.localIdentifier
            cell.imageBaseView.shouldActivate = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: cellSize, contentMode: PHImageContentMode.aspectFit, options: nil) { (image, userInfo) -> Void in
                
                //                self.photoImageView.image = image
                //                self.lblVideoTime.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.imageView.image = image
                    //                    cell.nameLabel.text = String(format: "%02d:%02d", Int((asset.duration / 60)), Int(asset.duration) % 60)
                    let duration = asset.duration // 2 minutes, 30 seconds
                    
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .positional
                    formatter.allowedUnits = [.minute, .second]
                    formatter.zeroFormattingBehavior = [.pad]
                    
                    if let formattedDuration = formatter.string(from: duration) {
                        let firstTwoCharacters = String(formattedDuration.prefix(2))
                        
                        if firstTwoCharacters == "00" {
                            var adjustedDuration = formattedDuration
                            adjustedDuration.remove(at: formattedDuration.startIndex)
                            cell.nameLabel.text = adjustedDuration
                        } else {
                            cell.nameLabel.text = formattedDuration
                        }
                        
                    }
                }
                
            }
            return cell
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width
        
        let numberOfCells = (availableWidth / 125).rounded(.down)
        
        let totalInset = (inset * CGFloat(numberOfCells)) + inset
        let availableCellWidth = availableWidth - totalInset
        
        var eachCellWidth = availableCellWidth / CGFloat(numberOfCells)
        eachCellWidth.round(.down)
        let size = CGSize(width: eachCellWidth, height: eachCellWidth + CGFloat(90))
        cellSize = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
            
            
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
}

