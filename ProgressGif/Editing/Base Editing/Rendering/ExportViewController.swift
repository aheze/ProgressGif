//
//  ExportViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import AVFoundation
import AVKit

class ExportViewController: UIViewController {
    
    var renderingAsset: AVAsset!
    var editingConfiguration: EditableEditingConfiguration!
    var playerURL = URL(fileURLWithPath: "")
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    
    @IBOutlet weak var processingLabel: UILabel!
    
    @IBOutlet weak var playerBaseView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressBaseView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var exportButtonBaseView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let exportSession = export {
            exportSession.cancelExport()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func exportButtonPresse(_ sender: Any) {
        
        let player = AVPlayer(url: playerURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
    
    var export: AVAssetExportSession?
    
    /// is proportional to the height of the video.
    /// multiply this by the editingConfiguration values
    var unit = CGFloat(1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lload")
        
        
        processingLabel.alpha = 0
        
//        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.processingLabel.alpha = 1
//        }, completion: nil)
        
//        UIView.animate(withDuration: 2, animations: {
//            self.processingLabel.alpha = 1
//        })
        
        playerBaseView.layer.cornerRadius = 12
        playerBaseView.clipsToBounds = true
        
        exportButton.layer.cornerRadius = 12
        
        exportButton.alpha = 0
        
        if let urlAsset = renderingAsset as? AVURLAsset {
            render(from: urlAsset, with: editingConfiguration) { exportedURL in
                print("done")
                guard let exportedURL = exportedURL else {
                    return
                }
                
                self.playerURL = exportedURL
                self.finishedExport()
            }
        }
    }
    
    func updateProgress(to progress: Float) {
        let progressPercent = progress * 100
        progressLabel.fadeTransition(0.1)
        progressLabel.text = "\(Int(progressPercent))%"
    }
    
    func finishedExport() {
        processingLabel.layer.removeAllAnimations()
        
        progressLabel.text = "100%"
        imageView.alpha = 0
        
        if let image = playerURL.generateImage() {
            imageView.image = image
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6, options: .curveLinear, animations: {
            self.progressLabel.alpha = 0
            self.imageView.alpha = 1
            
            self.cancelButton.alpha = 0
            self.exportButton.alpha = 1
        }, completion: nil)
    }
}
