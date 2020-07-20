//
//  FromPhotos.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import MobileCoreServices
import Photos

//MARK:- Image Picker

class FromPhotosPicker: UIViewController {
    
    var windowStatusBarHeight = CGFloat(0)
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var videosLabel: UILabel!
    
    private lazy var collectionViewController: CollectionViewController? = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.inset = CGFloat(4)
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .photos
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosLabel.alpha = 0.7
        rightArrowImageView.alpha = 0.7
        
        _ = collectionViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        windowStatusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        collectionViewController?.windowStatusBarHeight = self.windowStatusBarHeight
        
    }
}

extension FromPhotosPicker {
   
}

extension ViewController: UIImagePickerControllerDelegate {

    func importVideo() {

        let photoPermissions = PHPhotoLibrary.authorizationStatus()

        switch photoPermissions {

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    //                    self.getVideo(fromSourceType: .photoLibrary)
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
            //            self.getVideo(fromSourceType: .photoLibrary)
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
