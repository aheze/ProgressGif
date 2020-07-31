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
    
    let pickerView = UIPickerView()
    
    let fpsOptionList: [FPS] = [.low, .medium, .normal, .high, .max]
    let fpsOptions = ["Low (10)", "Medium (15)", "Normal (24)", "High (30)", "Max (45)"]
    
    @IBOutlet weak var fpsView: UIView!
    @IBOutlet weak var fpsButton: InputViewButton!
    @IBAction func fpsButtonPressed(_ sender: Any) {
        
        let fpsFromString = fpsString.getFPS()
        
        print("current fps: \(fpsFromString)")
        if let firstIndex = fpsOptionList.firstIndex(of: fpsFromString) {
            pickerView.selectRow(firstIndex, inComponent: 0, animated: false)
        }
        
        fpsButton.becomeFirstResponder()
    }
    // MARK: - Default Bar Values
    @IBOutlet weak var defaultBarValuesBaseView: UIView!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightNumberStepper: NumberStepper!
    
    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var foregroundColorButton: UIButton!
    @IBAction func foregroundColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: UIColor(hexString: barForegroundColorHex), colorPickerType: .barForeground, sourceView: foregroundColorButton)
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundColorButton: UIButton!
    @IBAction func backgroundColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: UIColor(hexString: barBackgroundColorHex), colorPickerType: .barBackground, sourceView: backgroundColorButton)
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
        self.displayColorPicker(originalColor: UIColor(hexString: edgeShadowColorHex), colorPickerType: .edgeShadow, sourceView: shadowColorColorButton)
    }
    // MARK: - Default Value Storage
    let defaults = UserDefaults.standard
    
    var fpsString = FPS.normal.getString()
    
    var barHeight = 5
    var barForegroundColorHex = "FFB500"
    var barBackgroundColorHex = "F4F4F4"
    
    var edgeInset = 0
    var edgeCornerRadius = 0
    var edgeShadowIntensity = 0
    var edgeShadowRadius = 0
    var edgeShadowColorHex = "000000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topInset = headerBlurView.frame.height
        scrollView.contentInset.top = topInset
        scrollView.verticalScrollIndicatorInsets.top = topInset
        
        setUp()
        
    }
    
}
