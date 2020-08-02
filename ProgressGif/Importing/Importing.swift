//
//  Importing.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import Photos

extension ViewController {

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

    func askToGoToSettingsForPhotoLibrary() {
        let alert = UIAlertController(title: "Photo Library Permissions", message: "We need to access your photo library to import videos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: {(action: UIAlertAction) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

