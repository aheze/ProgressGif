//
//  PasteViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/2/20.
//

import UIKit

class PasteViewController: UIViewController {
    
    // MARK: - Header
    @IBOutlet weak var xButton: UIButton!
    @IBAction func xButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Preview
    @IBOutlet weak var baseImageHolderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Choose buttons
    
    @IBOutlet weak var pasteButton: UIButton!
    @IBAction func pasteButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBAction func chooseButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var pasteButtonWidthC: NSLayoutConstraint!
    @IBOutlet weak var inBetweenButtonC: NSLayoutConstraint!
    @IBOutlet weak var chooseButtonWidthC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pasteButtonWidthC.constant = 240
        inBetweenButtonC.constant = 0
        chooseButtonWidthC.constant = 0
    }
    
}
