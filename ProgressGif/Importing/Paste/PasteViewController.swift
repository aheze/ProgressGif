//
//  PasteViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/2/20.
//

import UIKit
import AVFoundation
import AVKit

enum URLError {
    case emptyClipboard
    case invalidURLFormat
    case urlCantBePlayed
}

class PasteViewController: UIViewController {
    
    // MARK: - URL Validation
    private var playerItem: AVPlayerItem?
    private var player = AVPlayer()
    private var playerItemContext = 0
    
    var temporaryURLForImport: URL?
    var assetForImport: AVAsset?
    var urlChecked: Bool = false {
        didSet {
            if urlChecked {
                chooseButton.isEnabled = true
                chooseButtonView.alpha = 1
            } else {
                chooseButton.isEnabled = false
                chooseButtonView.alpha = 0.6
            }
        }
    }
    
    // MARK: - Header
    @IBOutlet weak var xButton: UIButton!
    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Preview
    
    @IBOutlet weak var checkingView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var baseImageHolderView: UIView!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    @IBOutlet weak var imageBackgroundLeftC: NSLayoutConstraint!
    @IBOutlet weak var imageBackgroundRightC: NSLayoutConstraint!
    @IBOutlet weak var imageBackgroundTopC: NSLayoutConstraint!
    @IBOutlet weak var imageBackgroundBottomC: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: Any) {
        if urlChecked {
            if let avAsset = assetForImport {
                if let avAssetURL = avAsset as? AVURLAsset {
                    let player = AVPlayer(url: avAssetURL.url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                    }
                }
            }
        }
    }
    
    // MARK: - Choose buttons
    
    @IBOutlet weak var pasteButton: UIButton!
    @IBAction func pasteButtonPressed(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        if let string = pasteboard.string {
            if string.isValidURL {
                animateValidURLPasted(validURL: string)
            } else {
                animateInvalidURLPasted(urlError: .invalidURLFormat)
            }
        } else {
            animateInvalidURLPasted(urlError: .emptyClipboard)
        }
    }
    @IBOutlet weak var pasteButtonWidthC: NSLayoutConstraint!
    
    
    @IBOutlet weak var chooseButtonView: UIView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBAction func chooseButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var inBetweenButtonC: NSLayoutConstraint!
    @IBOutlet weak var chooseViewWidthC: NSLayoutConstraint!
    @IBOutlet weak var inBetweenChooseActivityC: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorWidthC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pasteButtonWidthC.constant = 240
        inBetweenButtonC.constant = 0
        chooseViewWidthC.constant = 0
        
        imageBackgroundView.layer.cornerRadius = 12
        
        pasteButton.layer.cornerRadius = 6
        chooseButtonView.layer.cornerRadius = 6
        chooseButtonView.clipsToBounds = true
        
        playButton.alpha = 0
        
        chooseButton.isEnabled = false
        chooseButtonView.alpha = 0.6
    }
}

extension PasteViewController {
    func animateValidURLPasted(validURL: String) {
        
        inBetweenButtonC.constant = 12
        chooseViewWidthC.constant = 160
        pasteButtonWidthC.constant = 140
        
        inBetweenChooseActivityC.constant = 6
        activityIndicatorWidthC.constant = 20
        
        activityIndicatorView.startAnimating()
        
        if let formattedURL = URL(string: validURL) {
            
            print("properly formatted")
            validateURL(url: formattedURL)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.activityIndicatorView.alpha = 1
        }) { _ in
            self.urlLabel.fadeTransition(0.3)
            self.urlLabel.text = "Valid URL Format!\n\(validURL)"
            self.pasteButton.setTitle("Repaste", for: .normal)
            self.chooseButton.setTitle("Checking...", for: .normal)
            
        }
    }
    func animateInvalidURLPasted(urlError: URLError) {
        
        inBetweenButtonC.constant = 0
        chooseViewWidthC.constant = 0
        pasteButtonWidthC.constant = 240
        
        inBetweenChooseActivityC.constant = 0
        activityIndicatorWidthC.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            
            self.urlChecked = false
            
            self.activityIndicatorView.stopAnimating()
            self.urlLabel.fadeTransition(0.3)
            
            switch urlError {
            case .emptyClipboard:
                self.urlLabel.text = "Clipboard is empty"
                self.pasteButton.setTitle("Paste", for: .normal)
            case .invalidURLFormat:
                self.urlLabel.text = "Invalid URL"
                self.pasteButton.setTitle("Repaste", for: .normal)
            case .urlCantBePlayed:
                self.urlLabel.text = "URL isn't a video"
                self.pasteButton.setTitle("Repaste", for: .normal)
            }
        }
    }
    
    /// URL is checked and saved, ready to import.
    func animateCheckedURL(validURL: URL) {
        if urlChecked {
            print("url checked")
            
            if let avAsset = assetForImport {
                print("has asset for import")
                if let resolution = avAsset.resolutionSize() {
                    print("originla res size: \(resolution)")
                    let currentImageLength = baseImageHolderView.frame.size.height
//                    let resolutionAspect =
                    
                    if resolution.width > resolution.height { /// fatter
                        let resolutionAspect = currentImageLength / resolution.width
                        let newResolutionWidth = resolution.width * resolutionAspect
                        let newResolutionHeight = newResolutionWidth * (resolution.height / resolution.width)
                        
                        print("1 new res size: w: \(newResolutionWidth), h: \(newResolutionHeight)")
                        let yOffset = (currentImageLength - newResolutionHeight) / 2
                        
                        print("yoffset: \(yOffset)")
                        print("set choose 1, \(self.urlChecked)")
                        
                        imageBackgroundLeftC.constant = 0
                        imageBackgroundRightC.constant = 0
//                        imageBackgroundTopC.constant = 40
//                        imageBackgroundBottomC.constant = 60
                        imageBackgroundTopC.constant = yOffset
                        imageBackgroundBottomC.constant = yOffset
                        
                        inBetweenButtonC.constant = 12
                        chooseViewWidthC.constant = 160
                        pasteButtonWidthC.constant = 140
                        
                        inBetweenChooseActivityC.constant = 0
                        activityIndicatorWidthC.constant = 0
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.view.layoutIfNeeded()
                            print("layout view")
                            self.activityIndicatorView.alpha = 0
                            self.urlLabel.alpha = 0
                        }) { _ in
                            self.activityIndicatorView.stopAnimating()
                            self.pasteButton.setTitle("Repaste", for: .normal)
                            self.chooseButton.setTitle("Choose", for: .normal)
                            print("set choose, \(self.urlChecked)")
                        }
                    } else {
                        let resolutionAspect = currentImageLength / resolution.height
                        let newResolutionHeight = resolution.height * resolutionAspect
                        let newResolutionWidth = newResolutionHeight * (resolution.width / resolution.height)
                        
                        print("2 new res size: w: \(newResolutionWidth), h: \(newResolutionHeight)")
                        let xOffset = (currentImageLength - newResolutionWidth) / 2
                        
                        imageBackgroundLeftC.constant = xOffset
                        imageBackgroundRightC.constant = xOffset
                        imageBackgroundTopC.constant = 0
                        imageBackgroundBottomC.constant = 0
                        
                        inBetweenButtonC.constant = 12
                        chooseViewWidthC.constant = 160
                        pasteButtonWidthC.constant = 140
                        
                        inBetweenChooseActivityC.constant = 0
                        activityIndicatorWidthC.constant = 0
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.view.layoutIfNeeded()
                            print("layout view")
                            self.activityIndicatorView.alpha = 0
                            self.urlLabel.alpha = 0
                        }) { _ in
                            self.activityIndicatorView.stopAnimating()
                            self.pasteButton.setTitle("Repaste", for: .normal)
                            self.chooseButton.setTitle("Choose", for: .normal)
                            print("set choose, \(self.urlChecked)")
                        }
                    }
                    
                    
                    
                }
                
            }
            
            
        } else {
            print("url not checked")
        }
    }
    
    func validateURL(url: URL) {
        URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
            
            guard let location = location else { return }
            let temporaryFileURL = TemporaryFileURL(extension: url.pathExtension)
            do {
                
                try FileManager.default.moveItem(at: location, to: temporaryFileURL.contentURL)
                
                self.temporaryURLForImport = temporaryFileURL.contentURL
                let avAsset = AVAsset(url: url)
                self.assetForImport = avAsset
                self.setUpPlayerItem(with: avAsset)
                
            } catch { print("Error downloading video \(error)") }
            
        }.resume()
    }
    
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            
            if status == .readyToPlay {
                urlChecked = true
                if let temporaryURL = temporaryURLForImport {
                    animateCheckedURL(validURL: temporaryURL)
                }
            } else {
                animateInvalidURLPasted(urlError: .urlCantBePlayed)
            }
        }
    }
}

public protocol ManagedURL {
    var contentURL: URL { get }
    func keepAlive()
}

public extension ManagedURL {
    func keepAlive() { }
}

extension URL: ManagedURL {
    public var contentURL: URL { return self }
}
public final class TemporaryFileURL: ManagedURL {
    public let contentURL: URL
    
    public init(extension ext: String) {
        contentURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
    deinit {
        DispatchQueue.global(qos: .utility).async { [contentURL = self.contentURL] in
            try? FileManager.default.removeItem(at: contentURL)
        }
    }
}
