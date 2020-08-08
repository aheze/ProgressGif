//
//  ExportViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import AVFoundation
import AVKit
import SwiftyGif
import LinkPresentation

class ExportViewController: UIViewController {
    
    var shouldPresentError = false
    
    var renderingAsset: AVAsset!
    var editingConfiguration: EditableEditingConfiguration!
    var playerURL = URL(fileURLWithPath: "")
    var exportedGifURL = URL(fileURLWithPath: "")
    
    /// for framerate
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    @IBOutlet weak var processingLabel: UILabel!
    
    @IBOutlet weak var playerBaseView: UIView!
    @IBOutlet weak var playerBackgroundView: UIView!
    @IBOutlet weak var playerBackgroundLeftC: NSLayoutConstraint!
    @IBOutlet weak var playerBackgroundRightC: NSLayoutConstraint!
    @IBOutlet weak var playerBackgroundTopC: NSLayoutConstraint!
    @IBOutlet weak var playerBackgroundBottomC: NSLayoutConstraint!
    
//    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressBaseView: UIView!
    
    @IBOutlet weak var progressStatusLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var segmentIndicator: ANSegmentIndicator!
    
    @IBOutlet weak var exportButtonBaseView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let exportSession = export {
            exportSession.cancelExport()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func exportButtonPressed(_ sender: Any) {
        
        
        imageView.stopAnimatingGif()
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.imageView.startAnimatingGif()
        }
        self.present(activityViewController, animated: true, completion: nil)
        
        /// the following was for testing (the rendered video, not yet converted to gif)
        //        let player = AVPlayer(url: playerURL)
        //        let playerViewController = AVPlayerViewController()
        //        playerViewController.player = player
        //        self.present(playerViewController, animated: true) {
        //            playerViewController.player!.play()
        //        }
    }
    
    var export: AVAssetExportSession?
    
    /// is proportional to the height of the video.
    /// multiply this by the editingConfiguration values
    var unit = CGFloat(1)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldPresentError {
            shouldPresentError = false
            
            var fileExtension = ""
            if let urlAsset = renderingAsset as? AVURLAsset {
                fileExtension = "(.\(urlAsset.url.pathExtension)) "
            }
            print("file ext: \(fileExtension)")
            let alert = UIAlertController(title: "The file format \(fileExtension)is not supported", message: ".mp4 and .mov are recommended", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        /// animate pulsing processing fade in/out
        UIView.animate(withDuration: 0.5, animations: {
            self.processingLabel.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.processingLabel.alpha = 1
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.alpha = 0
        
        processingLabel.alpha = 0
        playerBaseView.layer.cornerRadius = 12
        playerBackgroundView.layer.cornerRadius = 12
        
        playerBaseView.clipsToBounds = true
        exportButton.layer.cornerRadius = 12
        exportButton.alpha = 0
        
        if let urlAsset = renderingAsset as? AVURLAsset {
            print("start , got asset")
            render(from: urlAsset, with: editingConfiguration) { exportedURL in
                print("finish export")
                guard let exportedURL = exportedURL else {
                    self.shouldPresentError = true
                    return
                }
                self.playerURL = exportedURL
                self.finishedExport()
            }
        }
        
        var settings = ANSegmentIndicatorSettings()
        settings.defaultSegmentColor = UIColor.tertiarySystemBackground
        settings.segmentBorderType = .round
        settings.segmentsCount = 2
        settings.segmentWidth = 16
        settings.animationDuration = 0.1
        settings.segmentColor = UIColor(named: "Yellorange")!
        
        segmentIndicator.settings = settings
    }
    
    func updateProgress(to progress: Float) {
        let progressPercent = progress * 50
        segmentIndicator.updateProgress(percent: Degrees(progressPercent))
        progressLabel.fadeTransition(0.1)
        progressLabel.text = "\(Int(progressPercent))%"
    }
    
    
    /// finished rendering video. Then need to convert to gif.
    func finishedExport() {
        segmentIndicator.updateProgress(percent: 50)
        progressLabel.text = "50%"
        
        progressStatusLabel.fadeTransition(0.6)
        
        let frameRate = self.defaults.string(forKey: DefaultKeys.fps)?.getFPS().getValue() ?? FPS.normal.getValue()
        progressStatusLabel.text = "Converting (\(frameRate) FPS)"
        
        var aspectRect = imageView.frame
        //        playerURL.generateImage() { (image) in
        //            if let generatedImage = image {
        //                self.imageView.image = image
        let adjustedRect = AVMakeRect(aspectRatio: renderingAsset.resolutionSize() ?? CGSize(width: 100, height: 100), insideRect: self.imageView.bounds)
        aspectRect = self.imageView.convert(adjustedRect, to: self.playerBaseView)
        
        self.playerBackgroundLeftC.constant = aspectRect.origin.x
        self.playerBackgroundTopC.constant = aspectRect.origin.y
        self.playerBackgroundRightC.constant = (self.playerBaseView.bounds.width - aspectRect.width) / 2
        self.playerBackgroundBottomC.constant = (self.playerBaseView.bounds.height - aspectRect.height) / 2
        //            }
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            self.playerBackgroundView.layer.cornerRadius = 0
            self.playerBaseView.layoutIfNeeded()
        })
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            /// start exporting to gif
            if let selfU = self {
                Regift.createGIFFromSource(selfU.playerURL, startTime: 0, duration: Float(CMTimeGetSeconds(selfU.renderingAsset.duration)), frameRate: frameRate, progress: { (progress) in
                    DispatchQueue.main.async {
                        let progressPercent = (progress * 50) + 50
                        selfU.segmentIndicator.updateProgress(percent: Degrees(progressPercent))
                        selfU.progressLabel.fadeTransition(0.1)
                        selfU.progressLabel.text = "\(Int(progressPercent))%"
                    }
                }) { (url) in
                    DispatchQueue.main.async {
                        if let gifUrl = url {
                            print("Convert to GIF completed! Export URL: \(gifUrl)")
                            selfU.finishedConversion(gifURL: gifUrl)
                            selfU.exportedGifURL = gifUrl
                        } else {
                            selfU.processingLabel.text = "Error"
                        }
                    }
                }
            }
        }
    }
    
    func finishedConversion(gifURL: URL) {
        processingLabel.layer.removeAllAnimations()
        
        imageView.setGifFromURL(gifURL)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.processingLabel.alpha = 0
            self.cancelButton.alpha = 0
            self.segmentIndicator.alpha = 0
            self.progressLabel.alpha = 0
            self.progressStatusLabel.alpha = 0
        }) { _ in
            
            self.processingLabel.text = "Here you go!"
            
            UIView.animate(withDuration: 0.6, animations: {
                self.processingLabel.alpha = 1
                self.imageView.alpha = 1
            })
            
            self.exportButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.exportButton.alpha = 1
                self.exportButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
}

extension ExportViewController: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage() // an empty UIImage is sufficient to ensure share sheet shows right actions
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return exportedGifURL
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.title = "A gif with a progress bar" // Preview Title
        let fileSize = exportedGifURL.fileSizeString
        print("fileSize: \(fileSize)")
        let formattedFileSize = fileSize.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        let startID = String(exportedGifURL.lastPathComponent.prefix(6))
        
        if let displayURL = URL(string: "\(formattedFileSize)~\(startID).gif") {
            print("display url: \(displayURL)")
            metadata.originalURL = displayURL
        }
        
        metadata.url = exportedGifURL
        metadata.imageProvider = NSItemProvider.init(contentsOf: exportedGifURL)
        metadata.iconProvider = NSItemProvider.init(contentsOf: exportedGifURL)

        return metadata
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
