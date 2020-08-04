//
//  Importing.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import Photos

extension ViewController {

    func importFromFiles() {
        documentPicker.displayPicker()
    }
    
    func presentPhotosPicker() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "FromPhotosPicker") as?
                FromPhotosPicker {
                
                vc.onDoneBlock = { [weak self] _ in
                    self?.refreshCollectionViewInsert()
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func presentPasteController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "PasteViewController") as?
                PasteViewController {
                
                vc.globalURL = self.globalURL
                vc.onDoneBlock = { [weak self] () in
                    self?.refreshCollectionViewInsert()
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    /// after dismissing the editing view controller, add the new project to the home screen
    func refreshCollectionViewInsert() {
        if let collectionVC = self.collectionViewController {
            collectionVC.updateAssets()
            if let cell = collectionVC.collectionView.cellForItem(at: collectionVC.selectedIndexPath) as? PhotoCell {
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
    }
}

