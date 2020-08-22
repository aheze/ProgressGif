//
//  ViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import Photos
import RealmSwift
import SnapKit

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var globalURL = URL(fileURLWithPath: "")
    var copyingFileToStorage = false
    
    
    @IBOutlet weak var welcomeReferenceView: UIView!
    @IBOutlet var welcomeView: UIView!
    
    
    // MARK: - Header
    @IBOutlet weak var visualEffectView: UIVisualEffectView! /// the top bar
    @IBOutlet weak var overlayColorView: UIView!
    @IBOutlet weak var overlayBlurView: UIVisualEffectView!
    @IBOutlet weak var topMarginC: NSLayoutConstraint!
    
    @IBOutlet weak var logoButton: UIButton!
    @IBAction func logoButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 13.0, *) {
            let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            topMarginC.constant = statusHeight
        } else {
            
            let statusHeight = UIApplication.shared.statusBarFrame.height
            topMarginC.constant = statusHeight
            // Fallback on earlier versions
        }
        
        
        view.layoutIfNeeded()
        collectionViewController?.topInset = visualEffectView.frame.height
        collectionViewController?.updateTopInset()
    }
    
    // MARK: - Help
    
    @IBOutlet weak var helpButton: UIButton!
    @IBAction func helpButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ImportInfoViewController") as? ImportInfoViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Warning flag
    var shouldGoToSettings = false
    @IBOutlet weak var photoPermissionWarningView: UIView!
    @IBOutlet weak var photoPermissionExplanationView: UIView!
    @IBOutlet weak var photoPermissionExplanationTopC: NSLayoutConstraint!
    @IBOutlet weak var photoPermissionWarningHeightC: NSLayoutConstraint!
    @IBOutlet weak var photoWarningButton: UIButton!
    @IBAction func photoWarningButtonPressed(_ sender: Any) {
        animatePermissionExplanationOpen()
    }
    @IBOutlet weak var closePhotoPermissionButton: UIButton!
    @IBAction func closePhotoPermissionButtonPressed(_ sender: Any) {
        animatePermissionWarningClose()
    }
    
    @IBOutlet weak var grantPhotoAccessButton: UIButton!
    @IBAction func grantPhotoAccessButtonPressed(_ sender: Any) {
        if shouldGoToSettings {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.animatePermissionWarningClose()
                        self.collectionViewController?.getAssetFromProjects()
                        self.collectionViewController?.collectionView.reloadData()
                    }
                } else {
                    self.shouldGoToSettings = true
                    DispatchQueue.main.async {
                        self.grantPhotoAccessButton.setTitle("Go to Settings", for: .normal)
                    }
                    
                }
            }
        }
    }
    func animatePermissionWarningClose() {
        photoPermissionWarningHeightC.constant = 0
        photoPermissionExplanationTopC.constant = -20
        
        let topInset = visualEffectView.frame.height
        self.collectionViewController?.topInset = topInset
        if #available(iOS 11.1, *) {
            self.collectionViewController?.collectionView.verticalScrollIndicatorInsets.top = topInset
        } else {
            self.collectionViewController?.collectionView.scrollIndicatorInsets.top = topInset
            // Fallback on earlier versions
        }
        self.collectionViewController?.collectionView.contentInset.top = topInset
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.photoPermissionWarningView.alpha = 0
            self.closePhotoPermissionButton.alpha = 0
            self.photoPermissionExplanationView.alpha = 0
            
        }) { _ in
            self.photoPermissionExplanationView.isUserInteractionEnabled = false
        }
    }
    
    func animatePermissionWarningOpen() {
        let photoPermissions = PHPhotoLibrary.authorizationStatus()
        switch photoPermissions {
        case .notDetermined:
            shouldGoToSettings = false
        case .denied:
            shouldGoToSettings = true
            grantPhotoAccessButton.setTitle("Go to Settings", for: .normal)
        default:
            print("default warning open, TEST")
        }
        
        let topInset = visualEffectView.frame.height + 40
        self.collectionViewController?.topInset = topInset
        self.collectionViewController?.collectionView.verticalScrollIndicatorInsets.top = topInset
        
        photoPermissionWarningHeightC.constant = 40
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.photoPermissionWarningView.alpha = 1
            self.closePhotoPermissionButton.alpha = 1
            self.photoPermissionWarningView.alpha = 1
        })
    }
    
    func animatePermissionExplanationOpen() {
        photoPermissionExplanationView.isUserInteractionEnabled = true
        grantPhotoAccessButton.layer.cornerRadius = 6
        photoPermissionExplanationTopC.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.photoPermissionExplanationView.alpha = 1
        })
    }
    
    
    // MARK: - Import From Files
    var documentPicker: DocumentPicker!
    
    // MARK: - Photos Collection View
    
    lazy var collectionViewController: CollectionViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.inset = CGFloat(4)
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .projects
            viewController.globalURL = self.globalURL
            viewController.displayWelcome = { [weak self] display in
                if display {
                    if let selfU = self {
                        
                        selfU.welcomeReferenceView.addSubview(selfU.welcomeView)
                        selfU.welcomeView.alpha = 0
                        
                        selfU.welcomeReferenceView.isUserInteractionEnabled = true
                        
                        selfU.welcomeView.snp.makeConstraints { (make) in
                            make.edges.equalToSuperview()
                        }
                        
                        UIView.animate(withDuration: 0.6, animations: {
                            selfU.welcomeView.alpha = 1
                        })
                    }
                } else {
                    if let selfU = self {
                        
                        selfU.welcomeView.removeFromSuperview()
                        selfU.welcomeReferenceView.isUserInteractionEnabled = false
                    }
                }
            }
            
            viewController.displayPhotoPermissionWarning = { [weak self] () in
                print("display!!!!!")
                
                DispatchQueue.main.async {
                    self?.animatePermissionWarningOpen()
                }
            }
            
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    // MARK: - Add button
    
    var addButtonIsPressed = false
    @IBOutlet weak var addButton: CustomButton!
    @IBAction func addButtonTouchDown(_ sender: Any) {
        handleAddButtonTouchDown()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        handleAddButtonPress()
    }
    
    @IBAction func addButtonTouchUpOutside(_ sender: Any) {
        handleAddButtonTouchUpOutside()
    }

    // MARK: - Import options
    
    @IBOutlet weak var importVideoLabel: UILabel!
    @IBOutlet weak var importVideoBottomC: NSLayoutConstraint! /// 26
    let importVideoBottomCShownConstant = CGFloat(32)
    let importVideoBottomCHiddenConstant = CGFloat(26)
    
    @IBOutlet weak var filesButton: CustomButton!
    @IBOutlet weak var photosButton: CustomButton!
    @IBOutlet weak var clipboardButton: CustomButton!
    
    @IBAction func filesTouchDown(_ sender: Any) {
        filesButton.scaleDown()
    }
    
    @IBAction func filesPressed(_ sender: Any) {
        filesButton.scaleUp()
        importFromFiles()
        handleAddButtonPress()
    }
    
    @IBAction func filesTouchUpOutside(_ sender: Any) {
        filesButton.scaleUp()
    }
    
    @IBAction func photosTouchDown(_ sender: Any) {
        photosButton.scaleDown()
    }
    
    @IBAction func photosPressed(_ sender: Any) {
        photosButton.scaleUp()
        presentPhotosPicker()
        handleAddButtonPress()
    }
    
    @IBAction func photosTouchUpOutside(_ sender: Any) {
        photosButton.scaleUp()
    }
    
    @IBAction func clipboardTouchDown(_ sender: Any) {
        clipboardButton.scaleDown()
    }
    @IBAction func clipboardPressed(_ sender: Any) {
        clipboardButton.scaleUp()
        presentPasteController()
        handleAddButtonPress()
    }
    @IBAction func clipboardTouchUpOutside(_ sender: Any) {
        clipboardButton.scaleUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoPermissionWarningHeightC.constant = 0
        photoPermissionWarningView.alpha = 0
        closePhotoPermissionButton.alpha = 0
        photoPermissionWarningView.alpha = 0
        photoPermissionExplanationView.alpha = 0
        photoPermissionExplanationView.isUserInteractionEnabled = false
        
        welcomeReferenceView.isUserInteractionEnabled = false
        /// make the import from files, import from photos, and import from clipboard buttons transparent
        setUpButtonAlpha()
        
        overlayBlurView.alpha = 0
        overlayColorView.alpha = 0
        
        guard let url = URL.createFolder(folderName: "ProgressGifStoredVideos") else {
            print("Can't create url")
            return
        }
        
        globalURL = url
        
        print("global url: \(url)")
        /// initialize the collection view
        _ = collectionViewController
        
        documentPicker = DocumentPicker(presentationController: self, delegate: self)
        
        if #available(iOS 13.0, *) {
            print("set ios13")
            addButton.setImage(UIImage(systemName: "plus")!, for: .normal)
        } else {
            addButton.setImage(UIImage(named: "largerPlus")!, for: .normal)
            addButton.tintColor = UIColor(named: "Yellorange")
            addButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            print("not avail")
            // Fallback on earlier versions
        }
    
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        func didPickDocument(document: Document?) {
//            if let pickedDoc = document {
//                let fileURL = pickedDoc.fileURL
//                saveDocument(temporaryDocumentURL: fileURL)
//            }
//        }
//        documentPicker = DocumentPicker(presentationController: self, delegate: self)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            let windowStatusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            collectionViewController?.windowStatusBarHeight = windowStatusBarHeight
        } else {
            
            let windowStatusBarHeight = UIApplication.shared.statusBarFrame.height
            collectionViewController?.windowStatusBarHeight = windowStatusBarHeight
            // Fallback on earlier versions
        }
        
        
    }


}

//class ViewControllers: UIViewController, DocumentDelegate {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        /// set up the document picker
//        documentPicker = DocumentPicker(presentationController: self, delegate: self)
//    }
//    
//    /// callback from the document picker
//    func didPickDocument(document: Document?) {
//        if let pickedDoc = document {
//            let fileURL = pickedDoc.fileURL
//            
//            /// do what you want with the file URL
//        }
//    }
//}






