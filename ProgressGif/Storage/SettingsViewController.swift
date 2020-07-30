//
//  SettingsViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Header
    @IBOutlet weak var headerBlurView: UIVisualEffectView!
    @IBAction func headerCloseButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - General
    @IBOutlet weak var generalBaseView: UIView!
    
    @IBOutlet weak var fpsView: UIView!
    @IBOutlet weak var fpsButton: UIButton!
    @IBAction func fpsButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Default Bar Values
    @IBOutlet weak var defaultBarValuesBaseView: UIView!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightNumberStepper: NumberStepper!
    
    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var foregroundColorButton: UIButton!
    @IBAction func foregroundColorPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundColorButton: UIButton!
    @IBAction func backgroundColorPressed(_ sender: Any) {
    }
    
    // MARK: - Default Edge Values
    @IBOutlet weak var defaultEdgeValuesBaseView: UIView!
    
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var insetNumberStepper: NumberStepper!
    
    @IBOutlet weak var cornerRadiusView: UIView!
    @IBOutlet weak var cornerRadiusNumberStepper: NumberStepper!
    
    @IBOutlet weak var shadowIntensityView: UIView!
    @IBOutlet weak var shadowIntensityNumberStepper: NumberStepper!
    
    @IBOutlet weak var shadowRadiusView: UIView!
    @IBOutlet weak var shadowRadiusNumberStepper: NumberStepper!
    
    @IBOutlet weak var shadowColorView: UIView!
    @IBOutlet weak var shadowColorColorButton: UIButton!
    @IBAction func shadowColorColorPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
}
