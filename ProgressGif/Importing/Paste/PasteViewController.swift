//
//  PasteViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/2/20.
//

import UIKit
import AVFoundation
import AVKit
import RealmSwift

enum URLError {
    case emptyClipboard
    case invalidURLFormat
    case urlCantBePlayed
    case customMessage
}

// MARK: - Import via paste URL
class PasteViewController: UIViewController {
    
    let realm = try! Realm()
    var globalURL = URL(fileURLWithPath: "")
    var onDoneBlock: (() -> Void)? /// refresh the Gallery collection view once the user finished editing a gif
    
    // MARK: - URL Validation
    private var playerItem: AVPlayerItem?
    private var player = AVPlayer()
    private var playerItemContext = 0
    private var playerImage: UIImage?
    
    var temporaryURLForImport: TemporaryFileURL?
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
    @IBOutlet weak var chooseButtonLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    
    @IBAction func chooseButtonDown(_ sender: Any) {
        if urlChecked {
            UIView.animate(withDuration: 0.1, animations: {
                self.chooseButtonLabel.alpha = 0.2
            })
        }
    }
    @IBAction func chooseButtonPressed(_ sender: Any) {
        if urlChecked {
            if let avAsset = assetForImport,
                let fromURL = temporaryURLForImport,
                let thumbnail = playerImage {
                fromURL.keepAlive()
                presentEditingVC(asset: avAsset, pathExtension: fromURL.contentURL.pathExtension, fromURL: fromURL.contentURL, thumbnailImage: thumbnail)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.chooseButtonLabel.alpha = 1
            })
        }
    }
    @IBAction func chooseButtonUpOutside(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseButtonLabel.alpha = 1
        })
    }
    @IBAction func chooseButtonTouchCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseButtonLabel.alpha = 1
        })
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
        
        imageView.alpha = 0
        playButton.alpha = 0
        playButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
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
            validateURL(url: formattedURL)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.activityIndicatorView.alpha = 1
        }) { _ in
            self.urlLabel.fadeTransition(0.3)
            self.urlLabel.text = "Valid URL Format!\n\(validURL)"
            self.pasteButton.setTitle("Repaste", for: .normal)
        }
    }
    func animateInvalidURLPasted(urlError: URLError, customMessage: String = "") {
        
        imageBackgroundLeftC.constant = 0
        imageBackgroundRightC.constant = 0
        imageBackgroundTopC.constant = 0
        imageBackgroundBottomC.constant = 0
        
        inBetweenButtonC.constant = 0
        chooseViewWidthC.constant = 0
        pasteButtonWidthC.constant = 240
        
        inBetweenChooseActivityC.constant = 0
        activityIndicatorWidthC.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.imageBackgroundView.layer.cornerRadius = 12
            self.imageView.alpha = 0
            self.playButton.alpha = 0
            self.playButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            self.urlLabel.alpha = 1
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
            case .customMessage:
                self.urlLabel.text = customMessage
                self.pasteButton.setTitle("Repaste", for: .normal)
            }
        }
    }
    
    /// URL is checked and saved, ready to import.
    func animateCheckedURL(validURL: TemporaryFileURL) {
        if urlChecked {
            if let avAsset = assetForImport {
                if let resolution = avAsset.resolutionSize() {
                    let currentImageLength = baseImageHolderView.frame.size.height
                    
                    
                    if resolution.width > resolution.height { /// fatter
                        let resolutionAspect = currentImageLength / resolution.width
                        let newResolutionWidth = resolution.width * resolutionAspect
                        let newResolutionHeight = newResolutionWidth * (resolution.height / resolution.width)
                        let yOffset = (currentImageLength - newResolutionHeight) / 2
                        
                        imageBackgroundLeftC.constant = 0
                        imageBackgroundRightC.constant = 0
                        imageBackgroundTopC.constant = yOffset
                        imageBackgroundBottomC.constant = yOffset
                        
                        inBetweenButtonC.constant = 12
                        chooseViewWidthC.constant = 160
                        pasteButtonWidthC.constant = 140
                        
                        inBetweenChooseActivityC.constant = 0
                        activityIndicatorWidthC.constant = 0
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.view.layoutIfNeeded()
                            self.activityIndicatorView.alpha = 0
                            self.urlLabel.alpha = 0
                            self.imageBackgroundView.layer.cornerRadius = 0
                        }) { _ in
                            self.activityIndicatorView.stopAnimating()
                            self.pasteButton.setTitle("Repaste", for: .normal)
                            
                            validURL.keepAlive()
                            validURL.contentURL.generateImage { (generatedImage) in
                                print("get generated")
                                if let image = generatedImage {
                                    self.playerImage = image
                                    self.imageView.image = image
                                    UIView.animate(withDuration: 0.5, animations: {
                                        self.imageView.alpha = 1
                                        self.playButton.alpha = 1
                                        self.playButton.transform = .identity
                                    })
                                }
                            }
                        }
                    } else {
                        let resolutionAspect = currentImageLength / resolution.height
                        let newResolutionHeight = resolution.height * resolutionAspect
                        let newResolutionWidth = newResolutionHeight * (resolution.width / resolution.height)
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
                            self.activityIndicatorView.alpha = 0
                            self.urlLabel.alpha = 0
                        }) { _ in
                            self.activityIndicatorView.stopAnimating()
                            self.pasteButton.setTitle("Repaste", for: .normal)
                        }
                    }
                }
                
            }
        }
    }
    
    func validateURL(url: URL) {
        URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
            
            if let errorMessage = error {
                let message = errorMessage.localizedDescription
                DispatchQueue.main.async {
                    self.animateInvalidURLPasted(urlError: .customMessage, customMessage: "Error: \(message)")
                }
            } else {
                guard let location = location else { return }
                let temporaryFileURL = TemporaryFileURL(extension: url.pathExtension)
                do {
                    try FileManager.default.moveItem(at: location, to: temporaryFileURL.contentURL)
                    
                    self.temporaryURLForImport = temporaryFileURL
                    let avAsset = AVAsset(url: url)
                    self.assetForImport = avAsset
                    self.setUpPlayerItem(with: avAsset)
                    
                } catch {
                    print("Error downloading video \(error)")
                    self.animateInvalidURLPasted(urlError: .customMessage, customMessage: "The video couldn't be downloaded.")
                }
            }
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

// MARK: - Temporary URL extensions
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
