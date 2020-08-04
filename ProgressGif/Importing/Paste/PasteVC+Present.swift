//
//  PasteVC+Present.swift
//  ProgressGif
//
//  Created by Zheng on 8/3/20.
//

import UIKit
import AVFoundation

extension PasteViewController {
    func presentEditingVC(asset: AVAsset, pathExtension: String, fromURL: URL, thumbnailImage: UIImage) {
        
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyy"
        let dateAsString = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmmss-SSSS"
        let timeAsString = timeFormatter.string(from: date)
        
        let timeName = "=\(dateAsString)=\(timeAsString)"
        let permanentFileURL = globalURL.appendingPathComponent(timeName).appendingPathExtension(pathExtension)
        let permanentFileEnding = permanentFileURL.lastPathComponent
        
        print("perma file: \(permanentFileURL), ending: \(permanentFileEnding)")
        DispatchQueue.global().async {
            
            do {
                let videoData = try Data(contentsOf: fromURL)
                try videoData.write(to: permanentFileURL, options: .atomic)
                
                DispatchQueue.main.async {
                    let avAsset = AVAsset(url: permanentFileURL)
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
                    metadata.duration = duration.getFormattedString() ?? "0:01"
                    
                    metadata.copiedFileIntoStorage = true
                    metadata.filePathEnding = permanentFileEnding
                    
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
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.statusHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                        self.present(viewController, animated: true, completion: nil)
                        
                        //                        permanentFileURL.generateImage { (generatedImage) in
                        //                            if let image = generatedImage {
                        viewController.imageView.image = thumbnailImage
                        //                            }
                        print("set")
                        viewController.setUpDrawing(with: viewController.editingConfiguration)
                        //                        }
                        
                        viewController.onDoneBlock = { [weak self] _ in
                            self?.onDoneBlock?()
                        }
                    }
                }
            } catch {
                print("Error making video data: \(error)")
            }
        }
    }
}
