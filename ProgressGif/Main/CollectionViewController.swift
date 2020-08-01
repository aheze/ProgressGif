//
//  CollectionViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/11/20.
//

import UIKit
import Photos
import RealmSwift


enum CollectionType {
    case projects
    case photos
}
class ProjectThumbnailAsset: NSObject {
    var project = Project()
    var dateCreated = Date()
    var savingMethod = ProjectSavingMethod.realmSwift
    var phAsset: PHAsset?
    var filePathEnding: String?
}

class CollectionViewController: UIViewController {
    
    let transition = PopAnimator()
    var onDoneBlock: ((Bool) -> Void)?
    
    let realm = try! Realm()
    var globalURL = URL(fileURLWithPath: "")
    
    var windowStatusBarHeight = CGFloat(0)
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    var collectionType = CollectionType.projects
    var projects: Results<Project>?
    
    var photoAssets: PHFetchResult<PHAsset>!
    var projectThumbs = [ProjectThumbnailAsset]()
    
    var cellSize = CGSize(width: 100, height: 100)
    var topInset = CGFloat(80)
    var inset = CGFloat(16)
    
    @IBOutlet weak var collectionView: UICollectionView!
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: (inset * 4) + topInset, left: inset, bottom: inset, right: inset)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        if collectionType == .projects {
            getAssetFromProjects()
        } else {
            getAssetFromPhoto()
        }
    }
    
    func updateTopInset() {
        collectionView.contentInset = UIEdgeInsets(top: (inset * 4) + topInset, left: inset, bottom: inset, right: inset)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
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
    func updateAssets() {
        getAssetFromProjects()
        
        let firstIndex = IndexPath(item: 0, section: 0)
        collectionView.insertItems(at: [firstIndex])
    }
    func getAssetFromProjects() {
        
        projects = realm.objects(Project.self)
        
        if let projs = projects {
            projects = projs.sorted(byKeyPath: "dateCreated", ascending: false)
        }
        
        var thumbs = [ProjectThumbnailAsset]()
        var projectsImportedFromPhotos = [Project]()
        
        if let projs = projects {
            for proj in projs {
                if proj.metadata?.copiedFileIntoStorage ?? false { /// saved into documents directory
                    let thumbnail = ProjectThumbnailAsset()
                    thumbnail.project = proj
                    thumbnail.savingMethod = .documentsDirectory
                    thumbnail.filePathEnding = proj.metadata?.filePathEnding
                    thumbnail.dateCreated = proj.dateCreated
                    
                    thumbs.append(thumbnail)
                } else {
                    projectsImportedFromPhotos.append(proj)
                }
            }
        }
        
        var photoIDs = [String]()
        for project in projectsImportedFromPhotos {
            if let identifier = project.metadata?.localIdentifier {
                photoIDs.append(identifier)
            }
        }
        
        var rawPHAssets: PHFetchResult<PHAsset>!
        rawPHAssets = PHAsset.fetchAssets(withLocalIdentifiers: photoIDs, options: nil)
        
        if rawPHAssets != nil {
            if rawPHAssets.count > 0 {
                /// the user may have multiple projects with the same video
                /// so we need to make a new array that contains possible duplicate video
                let phAssets = rawPHAssets.objects(at: IndexSet(0...rawPHAssets.count - 1))
                
                for project in projectsImportedFromPhotos {
                    if let identifier = project.metadata?.localIdentifier {
                        for asset in phAssets {
                            if asset.localIdentifier == identifier {
                                let thumbnail = ProjectThumbnailAsset()
                                thumbnail.project = project
                                thumbnail.savingMethod = .realmSwift
                                thumbnail.phAsset = asset
                                thumbnail.dateCreated = project.dateCreated
                                
                                thumbs.append(thumbnail)
                            }
                        }
                    }
                }
            }
        }
        
        
        thumbs = thumbs.sorted(by: {
            $0.dateCreated.compare($1.dateCreated) == .orderedDescending
        })

        projectThumbs = thumbs
        collectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setUpDismissCompletion()
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionType == .projects {
            return projectThumbs.count
        } else {
            return photoAssets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photoCell = cell as? PhotoCell {
            photoCell.layoutIfNeeded()
            photoCell.contentView.layer.masksToBounds = true
            if let drawingRect = photoCell.imageView.roundCornersForAspectFit(radius: 6) {
                photoCell.imageBaseView.shouldActivate = true
                photoCell.imageBaseView.updateShadow(rect: drawingRect, radius: 6)
                photoCell.realFrameRect = drawingRect
                
                photoCell.drawingLeftC.constant = drawingRect.origin.x
                photoCell.drawingRightC.constant = (photoCell.imageBaseView.frame.width - drawingRect.width) / 2
                photoCell.drawingTopC.constant = drawingRect.origin.y
                photoCell.drawingBottomC.constant = (photoCell.imageBaseView.frame.height - drawingRect.height) / 2
                
                photoCell.drawingView.layer.cornerRadius = 6
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionType == .projects {
            selectedIndexPath = indexPath
            
            let editingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
                "EditingViewController") as! EditingViewController
            editingViewController.transitioningDelegate = self
            
            let projectThumb = projectThumbs[indexPath.item]
            editingViewController.project = projectThumb.project
            editingViewController.onDoneBlock = self.onDoneBlock
            
            if projectThumb.savingMethod == .realmSwift {
                
                guard let savedPHAsset = projectThumb.phAsset else { print("no phAsset"); return }
                
                PHCachingImageManager().requestAVAsset(forVideo: savedPHAsset, options: nil) { (avAsset, _, _) in
                    editingViewController.avAsset = avAsset
                    editingViewController.onDoneBlock = { _ in
                        
                        self.getAssetFromProjects()
                        self.collectionView.reloadItems(at: [self.selectedIndexPath])
                        if let cell = collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell {
                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 1, animations: {
                                    cell.drawingView.backgroundColor = UIColor.white
                                }) { _ in
                                    UIView.animate(withDuration: 1, animations: {
                                        cell.drawingView.backgroundColor = UIColor.clear
                                    })
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.present(editingViewController, animated: true, completion: nil)
                    }
                }
            } else {
                
                guard let fileURLEnding = projectThumb.filePathEnding else { print("no url from filePathEnding"); return }
                let videoURL = globalURL.appendingPathComponent(fileURLEnding)
                
                let avAsset = AVAsset(url: videoURL)
                editingViewController.avAsset = avAsset
                editingViewController.onDoneBlock = { _ in
                    
                    self.getAssetFromProjects()
                    self.collectionView.reloadItems(at: [self.selectedIndexPath])
                    if let cell = collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1, animations: {
                                cell.drawingView.backgroundColor = UIColor.white
                            }) { _ in
                                UIView.animate(withDuration: 1, animations: {
                                    cell.drawingView.backgroundColor = UIColor.clear
                                })
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.present(editingViewController, animated: true, completion: nil)
                }
            }
        } else {
            let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
                "PhotoPageViewController") as! PhotoPageViewController
            
            selectedIndexPath = indexPath
            mainContentVC.transitioningDelegate = mainContentVC.transitionController
            mainContentVC.transitionController.fromDelegate = self
            mainContentVC.transitionController.toDelegate = mainContentVC
            mainContentVC.delegate = self
            mainContentVC.currentIndex = self.selectedIndexPath.item
            mainContentVC.photoAssets = photoAssets
            mainContentVC.normalStatusBarHeight = windowStatusBarHeight
            mainContentVC.onDoneBlock = onDoneBlock
            
            present(mainContentVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCellId", for: indexPath) as! PhotoCell
        
        if collectionType == .projects {
            cell.progressBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.progressBackgroundView.layer.cornerRadius = 6
            cell.progressBackgroundView.clipsToBounds = true
            cell.imageBaseView.shouldActivate = true
            
            let projectThumb = projectThumbs[indexPath.item]
            
            let title = projectThumb.project.title
            cell.nameLabel.text = title
            
            if let configuration = projectThumb.project.configuration {
                cell.progressBackgroundView.backgroundColor = UIColor(hexString: configuration.barBackgroundColorHex)
                cell.progressBarView.backgroundColor = UIColor(hexString: configuration.barForegroundColorHex)
            }
            
            if projectThumb.savingMethod == .realmSwift {
                guard let savedPHAsset = projectThumb.phAsset else { print("no phAsset"); return cell }
                cell.representedAssetIdentifier = savedPHAsset.localIdentifier
                
                PHImageManager.default().requestImage(for: savedPHAsset, targetSize: cellSize, contentMode: PHImageContentMode.aspectFit, options: nil) { (image, userInfo) -> Void in
                    if cell.representedAssetIdentifier == savedPHAsset.localIdentifier {
                        cell.imageView.image = image
                        let duration = savedPHAsset.duration
                        cell.secondaryLabel.text = duration.getFormattedString()
                    }
                }
            } else {
                
                guard let fileURLEnding = projectThumb.filePathEnding else { print("no url from filePathEnding"); return cell }
                
                let videoURL = globalURL.appendingPathComponent(fileURLEnding)
                
                
//                if let generatedImage = videoURL.generateImage() {
//                    cell.imageView.image = generatedImage
//                }
                let generatedData = videoURL.generateImageAndDuration()
                if let generatedImage = generatedData.0 {
                    cell.imageView.image = generatedImage
                }
                if let formattedString = generatedData.1 {
                    cell.secondaryLabel.text = formattedString
                }
            }
            return cell
            
        } else {
            
            let asset = photoAssets.object(at: indexPath.row)
            cell.representedAssetIdentifier = asset.localIdentifier
            cell.imageBaseView.shouldActivate = true
            cell.secondaryLabel.text = ""
            
            PHImageManager.default().requestImage(for: asset, targetSize: cellSize, contentMode: PHImageContentMode.aspectFit, options: nil) { (image, userInfo) -> Void in
                
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.imageView.image = image
                    let duration = asset.duration
                    cell.nameLabel.text = duration.getFormattedString()
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
        let size = CGSize(width: eachCellWidth, height: eachCellWidth + CGFloat(50))
        cellSize = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { suggestedActions in
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                
                let alert = UIAlertController(title: "Delete this project?", message: "This action can't be undone.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { _ in
                    
                    if let selectedProject = self.projects?[indexPath.item] {
                        do {
                            try self.realm.write {
                                self.realm.delete(selectedProject)
                            }
                        } catch {
                            print("Error deleting project: \(error)")
                        }
                        
                        self.getAssetFromProjects()
                        collectionView.performBatchUpdates({
                            self.collectionView.deleteItems(at: [indexPath])
                        }, completion: nil)
                        
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
            if self.collectionType == .projects {
                return UIMenu(title: "", children: [delete])
            } else {
                return nil
            }
        }
    }
}
extension CollectionViewController: PhotoPageViewControllerDelegate {
    func containerViewController(_ containerViewController: PhotoPageViewController, indexDidUpdate currentIndex: Int) {
        self.selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
    }
}
extension CollectionViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        
        if let cell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell {
            
            let cellFrame = self.collectionView.convert(cell.frame, to: self.view)
            if cellFrame.minY < self.collectionView.contentInset.top {
                self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .top, animated: false)
            } else if cellFrame.maxY > self.view.frame.height - self.collectionView.contentInset.bottom {
                self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        
        //Get a guarded reference to the cell's UIImageView
        let referenceImageView = getImageViewFromCollectionViewCell(for: self.selectedIndexPath)
        
        return referenceImageView
    }
    
    func getImageViewFrame() -> CGRect? {
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        
        //Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)
        
        var cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)
        
        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }
        
        let superCellFrame = self.collectionView.convert(unconvertedFrame, to: nil)
        let cellYDiff = superCellFrame.origin.y - cellFrame.origin.y
        let cellXDiff = superCellFrame.origin.x - cellFrame.origin.x
        
        cellFrame.origin.y += cellYDiff
        cellFrame.origin.x += cellXDiff
        
        ///works on ipad now
        ///need to fix this, no hardcoded values
        return cellFrame
    }
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        
        //Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)
        
        var cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)
        
        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }
        
        let superCellFrame = self.collectionView.convert(unconvertedFrame, to: nil)
        let cellYDiff = superCellFrame.origin.y - cellFrame.origin.y
        let cellXDiff = superCellFrame.origin.x - cellFrame.origin.x
        
        cellFrame.origin.y += cellYDiff
        cellFrame.origin.x += cellXDiff
        
        ///works on ipad now
        ///need to fix this, no hardcoded values
        return cellFrame
    }
    //This function prevents the collectionView from accessing a deallocated cell. In the event
    //that the cell for the selectedIndexPath is nil, a default UIImageView is returned in its place
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        
        //Get the array of visible cells in the collectionView
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            
            //Scroll the collectionView to the current selectedIndexPath which is offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            
            //Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            
            //Guard against nil values
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        }
        else {
            
            //Guard against nil return values
            guard let guardedCell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        }
        
    }
    
    //This function prevents the collectionView from accessing a deallocated cell. In the
    //event that the cell for the selectedIndexPath is nil, a default CGRect is returned in its place
    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        
        //Get the currently visible cells from the collectionView
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            
            //Scroll the collectionView to the cell that is currently offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            
            //Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                print("No guardedCell1")
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            
            let imageRect = guardedCell.realFrameRect!
            let newX = guardedCell.frame.origin.x + guardedCell.imageView.frame.origin.x + imageRect.origin.x
            let newY = guardedCell.frame.origin.y + guardedCell.imageView.frame.origin.y + imageRect.origin.y
            let newW = imageRect.width
            let newH = imageRect.height
            
            let realFrame = CGRect(x: newX, y: newY, width: newW, height: newH)
            return realFrame
        }
            //Otherwise the cell should be visible
        else {
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                print("No guardedCell3")
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            
            let imageRect = guardedCell.realFrameRect!
            let newX = guardedCell.frame.origin.x + guardedCell.imageView.frame.origin.x + imageRect.origin.x
            let newY = guardedCell.frame.origin.y + guardedCell.imageView.frame.origin.y + imageRect.origin.y
            let newW = imageRect.width
            let newH = imageRect.height
            
            let realFrame = CGRect(x: newX, y: newY, width: newW, height: newH)
            return realFrame
        }
    }
}
