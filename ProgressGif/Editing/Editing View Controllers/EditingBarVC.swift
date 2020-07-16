//
//  EditingBarVC.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

class EditingBarVC: UIViewController {
      
    
    @IBOutlet weak var heightBaseView: UIView!
    @IBOutlet weak var heightNumberStepper: NumberStepper!
    
    @IBOutlet weak var foregroundBaseView: UIView!
    @IBOutlet weak var foregroundColorButton: UIButton!
    
    
    @IBOutlet weak var backgroundBaseView: UIView!
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightBaseView.layer.cornerRadius = 6
        foregroundBaseView.layer.cornerRadius = 6
        backgroundBaseView.layer.cornerRadius = 6
        
        foregroundColorButton.layer.cornerRadius = 6
        backgroundColorButton.layer.cornerRadius = 6
    }
    
}
