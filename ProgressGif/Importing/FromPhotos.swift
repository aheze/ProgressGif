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
    
    var viewDidAppearLoaded = false
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var videosLabel: UILabel!
    
    @IBOutlet weak var photosLabelLeftC: NSLayoutConstraint!
    var photosLabelWidth = CGFloat(50)
    
    @IBOutlet weak var arrowLeftC: NSLayoutConstraint!
    @IBOutlet weak var arrowRightC: NSLayoutConstraint!
    
    
    private lazy var collectionViewController: CollectionViewController? = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
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
}

extension FromPhotosPicker {
   
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FromPhotosPicker") as? FromPhotosPicker {
            self.present(vc, animated: true, completion: nil)
        }

    }

    func askToGoToSettingsForPhotoLibrary() {
        let alert = UIAlertController(title: "Photo Library Permissions", message: "We need to access your photo library to import video", preferredStyle: .alert)
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

//    func getVideo(fromSourceType sourceType: UIImagePickerController.SourceType) {
//
//
//
//        //Check is source type available
//        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//            DispatchQueue.main.async {
//                let imagePickerController = UIImagePickerController()
//                imagePickerController.delegate = self
//                imagePickerController.sourceType = sourceType
//                imagePickerController.mediaTypes = [kUTTypeMovie as String]
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }
//    }
//
//    //MARK:- UIImagePickerViewDelegate.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        self.dismiss(animated: true) { [weak self] in
//
//            print("got video!")
//
//            //            guard let video = info[UIImagePickerController.InfoKey.orig]
//            //            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            //            //Setting image to your image view
//            //            self?.profileImgView.image = image
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }

}
