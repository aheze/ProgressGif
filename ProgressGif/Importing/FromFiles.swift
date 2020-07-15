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
        //        }
        print("import result : \(url)")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("import results : \(urls)")
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
    }
    
    
}
