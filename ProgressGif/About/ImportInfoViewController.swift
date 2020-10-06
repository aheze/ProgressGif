//
//  ImportInfoViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/4/20.
//

import UIKit

class ImportInfoViewController: UIViewController {
    
    @IBOutlet weak var doneBlurView: UIVisualEffectView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBlurView.clipsToBounds = true
        doneBlurView.layer.cornerRadius = doneBlurView.frame.size.height / 2
    }
}
