//
//  FromFiles.swift
//  ProgressGif
//
//  Created by Zheng on 7/11/20.
//

import UIKit
import MobileCoreServices



extension ViewController: UIDocumentPickerDelegate {
    func presentImportController() {
        let importController = UIDocumentPickerViewController(documentTypes: ["public.movie"], in: .import)
        importController.delegate = self
        present(importController, animated: true, completion: nil)
        
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        //        guard let myURL = urls.first else {
        //            return
        //        }
        print("import result : \(url)")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("import results : \(urls)")
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //        dismiss(animated: true, completion: nil)
    }
    
    
}

//class FromFilesPicker: UIViewController, UIDocumentPickerDelegate {
//
//    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    @IBOutlet weak var visualHeightC: NSLayoutConstraint!
//
//    @IBOutlet weak var filesImageView: UIImageView!
//    @IBOutlet weak var filesLabel: UILabel!
//    @IBOutlet weak var rightArrowImageView: UIImageView!
//    @IBOutlet weak var videosLabel: UILabel!
//
//    @IBOutlet weak var referenceView: UIView!
//
//
//    private lazy var filesViewController: UIDocumentPickerViewController = {
//        let importController = UIDocumentPickerViewController(documentTypes: ["public.movie"], in: .import)
//        importController.delegate = self
//        return importController
//
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        filesLabel.alpha = 0.7
//        rightArrowImageView.alpha = 0.7
//
////        add(childViewController: filesViewController, inView: referenceView)
////
////        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
////            self.visualHeightC.constant = 0
////            UIView.animate(withDuration: 0.8, animations: {
////                self.view.layoutIfNeeded()
////                self.filesImageView.alpha = 0
////                self.filesLabel.alpha = 0
////                self.rightArrowImageView.alpha = 0
////                self.videosLabel.alpha = 0
////            })
//        weak var pvc = self.presentingViewController
//        pvc?.present(self.filesViewController, animated: true, completion: nil)
////        })
//
//
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        //        guard let myURL = urls.first else {
//        //            return
//        //        }
//        print("import result : \(url)")
//    }
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        print("import results : \(urls)")
//    }
//
//
//
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        print("view was cancelled")
////        dismiss(animated: true, completion: nil)
//    }
//
//}
