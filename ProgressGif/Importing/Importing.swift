//
//  Importing.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import Photos

extension ViewController {

    func importVideo() {

        let photoPermissions = PHPhotoLibrary.authorizationStatus()

        switch photoPermissions {

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.presentFromPhotosPicker()
                }
            })
        case .restricted:
            let alert = UIAlertController(title: "Restricted 😢", message: "You're restricted from accessing the photo library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .denied:
            askToGoToSettingsForPhotoLibrary()
        case .authorized:
            presentFromPhotosPicker()
        @unknown default:
            break
        }
    }
    
    func presentFromPhotosPicker() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "FromPhotosPicker") as?
                FromPhotosPicker {
                
                vc.onDoneBlock = { _ in
                    print("done!!!")
                    
                    self.self.collectionViewController?.updateAssets()
//                    self.projects = self.realm.objects(Project.self)
//
//                    if let projs = self.projects {
//                        self.projects = projs.sorted(byKeyPath: "dateCreated", ascending: false)
//                    }
//
//                    self.collectionViewController?.projects = self.projects
//                    self.collectionViewController?.getAssetFromProjects()
//
//                    let firstIndex = IndexPath(item: 0, section: 0)
//                    self.collectionViewController?.collectionView.insertItems(at: [firstIndex])
                }
                self.present(vc, animated: true, completion: nil)
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

