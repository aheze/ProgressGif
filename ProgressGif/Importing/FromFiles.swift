//
//  FromFiles.swift
//  ProgressGif
//
//  Created by Zheng on 7/11/20.
//

import UIKit
import MobileCoreServices
import AVFoundation

extension ViewController: UIDocumentPickerDelegate {
    
//    override func present(_ viewControllerToPresent: UIViewController,
//                          animated flag: Bool,
//                          completion: (() -> Void)? = nil) {
//        if let editingVC = viewControllerToPresent as? EditingViewController {
//            print("print editing vc")
//            viewControllerToPresent.modalPresentationStyle = .fullScreen
//        }
//        super.present(viewControllerToPresent, animated: flag, completion: completion)
//    }
    
    
    func presentImportController() {
        let importController = UIDocumentPickerViewController(documentTypes: ["public.movie"], in: .import)
        importController.delegate = self
        present(importController, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        //        }
        print("import result : \(url)")
        
//        if !copyingFileToStorage {
//            copyingFileToStorage = true
            
            guard controller.documentPickerMode == .open, url.startAccessingSecurityScopedResource() else { return }
            defer {
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            saveDocument(temporaryDocumentURL: url)
//        }
        
    }
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
////            if !copyingFileToStorage {
////                copyingFileToStorage = true
//
//        guard let documentURL = urls.first else { return }
//        print("DocumentURL: \(documentURL)")
//
////        let sampleDocumentURL = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
////        saveDocument(temporaryDocumentURL: sampleDocumentURL)
//
//        let sampleURL = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//        saveDocument(temporaryDocumentURL: sampleURL)
////        let shouldStopAccessing = documentURL.startAccessingSecurityScopedResource()
////        defer {
////            if shouldStopAccessing {
////                documentURL.stopAccessingSecurityScopedResource()
////            }
////        }
////        NSFileCoordinator().coordinate(readingItemAt: documentURL, error: NSErrorPointer.none) { (fileURL) in
////            let file = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
////            saveDocument(temporaryDocumentURL: file)
////        }
//
//    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        let sampleURL = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
        let sampleURL = Bundle.main.url(forResource: "IMG_6678.MOV", withExtension: "")!
        saveDocument(temporaryDocumentURL: sampleURL)
    }
    
    
            
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        let sampleURL = Bundle.main.url(forResource: "IMG_6678.MOV", withExtension: "")!
        saveDocument(temporaryDocumentURL: sampleURL)
    }
}

extension ViewController {
    
    func saveDocument(temporaryDocumentURL: URL) {
        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMddyy"
//        let dateAsString = formatter.string(from: date)
//
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HHmmss-SSSS"
//        let timeAsString = timeFormatter.string(from: date)
//
//        let videoFileName = "=\(dateAsString)=\(timeAsString)"
//
//        let permanentFileURL = globalURL.appendingPathComponent(videoFileName)
//
//        DispatchQueue.global().async {
//            do {
//                let videoData = try Data(contentsOf: temporaryDocumentURL)
//                try videoData.write(to: permanentFileURL)
//            } catch {
//                print("Error making video data: \(error)")
//            }
//
//        }
        
        let avAsset = AVAsset(url: temporaryDocumentURL)
        let newProject = Project()
        newProject.title = "Untitled"
        newProject.dateCreated = date
        
        let configuration = EditingConfiguration()
        newProject.configuration = configuration
        
        let metadata = VideoMetadata()
        newProject.metadata = metadata
        
        if let videoResolution = avAsset.resolutionSize() {
            metadata.resolutionWidth = Int(videoResolution.width)
            metadata.resolutionHeight = Int(videoResolution.height)
        }
        
        let cmDuration = avAsset.duration
        let duration = CMTimeGetSeconds(cmDuration)
        metadata.duration = duration.getString() ?? "0:01"
        
        metadata.copiedFileIntoStorage = true
//        metadata.filePathEnding = videoFileName
        
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(newProject)
                }
            } catch {
                print("error adding object: \(error)")
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController {
                
                viewController.avAsset = avAsset
                viewController.project = newProject
//                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                
                viewController.onDoneBlock = { _ in
                    print("done! done!")
                }
            }
        }
        copyingFileToStorage = false
    }
}


//class Document: UIDocument {
//    var data: Data?
//    override func contents(forType typeName: String) throws -> Any {
//        guard let data = data else { return Data() }
//        return try NSKeyedArchiver.archivedData(withRootObject:data,
//            requiringSecureCoding: true)
//    }
//    override func load(fromContents contents: Any, ofType typeName:
//        String?) throws {
//        guard let data = contents as? Data else { return }
//        self.data = data
//    }
//}



//I'm presenting a UIDocumentPickerViewController to let the user import video files. I'm presenting it with no problem, like this:
//
//```
//let importController = UIDocumentPickerViewController(documentTypes: ["public.movie"], in: .import)
//importController.delegate = self
//present(importController, animated: true, completion: nil)
//```
//And I have the delegate methods set up as such:
//```
//...
//
//func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//    guard let documentURL = urls.first else { return }
//    print("DocumentURL: \(documentURL)")
//    saveDocument(temporaryDocumentURL: documentURL)
//}
//```
//This prints out
//```
//DocumentURL: file:///private/var/mobile/Containers/Data/Application/4069477D-3D29-4514-B045-B1DF40EDD1BD/tmp/com.example.ProgressGif-Inbox/SampleMovie.mpg
//```
//The URL looks valid, but inside `saveDocument(temporaryDocumentURL:)`, where I convert the url to an `AVAsset` and play it in an `AVPlayer`, it doesn't work. `AVPlayerItem.status` returns `.failed`.
//
//Meanwhile, if I use an example url, it works.
//```
//func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//    let sampleURL = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//    saveDocument(temporaryDocumentURL: sampleURL)
//}
//
//```
//I tried using `startAccessingSecurityScopedResource()` and checked out `NSFileCoordinator`, but no luck.
//```
//func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//    guard let documentURL = urls.first else { return }
//    print("DocumentURL: \(documentURL)")
//    let shouldStopAccessing = documentURL.startAccessingSecurityScopedResource()
//    defer {
//        if shouldStopAccessing {
//            documentURL.stopAccessingSecurityScopedResource()
//        }
//    }
//    NSFileCoordinator().coordinate(readingItemAt: documentURL, error: NSErrorPointer.none) { (fileURL) in
//        let file = URL(fileURLWithPath: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//        saveDocument(temporaryDocumentURL: file)
//    }
//}
//```
