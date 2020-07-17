//
//  EditingEdgesVC.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

protocol EditingEdgesChanged: class {
    func edgeInsetChanged(to inset: Int)
    func edgeCornerRadiusChanged(to radius: Int)
    func edgeShadowColorChanged(to color: UIColor)
    func backgroundColorChanged(to color: UIColor)
}

class EditingEdgesVC: UIViewController {
    
    weak var editingEdgesChanged: EditingEdgesChanged?
    
    var originalEdgeInset = 0
    var originalEdgeCornerRadius = 0
    var originalEdgeShadowColor = UIColor.black
    var originalEdgeBackgroundColor = UIColor.clear
    
    
    @IBOutlet weak var insetBaseView: UIView!
    @IBOutlet weak var cornerRadiusBaseView: UIView!
    @IBOutlet weak var shadowBaseView: UIView!
    @IBOutlet weak var backgroundBaseView: UIView!
    
    @IBOutlet weak var insetNumberStepper: NumberStepper!
    @IBOutlet weak var cornerRadiusNumberStepper: NumberStepper!
    
    @IBOutlet weak var shadowColorButton: UIButton!
    @IBAction func shadowColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: originalEdgeShadowColor, colorPickerType: .edgeShadow, sourceView: shadowColorButton)
    }
    
    @IBOutlet weak var backgroundColorButton: UIButton!
    @IBAction func backgroundColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: originalEdgeBackgroundColor, colorPickerType: .edgeBackground, sourceView: backgroundColorButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insetBaseView.layer.cornerRadius = 6
        cornerRadiusBaseView.layer.cornerRadius = 6
        shadowBaseView.layer.cornerRadius = 6
        backgroundBaseView.layer.cornerRadius = 6
        
        shadowColorButton.layer.cornerRadius = 6
        backgroundColorButton.layer.cornerRadius = 6
        
        setUpConfiguration()
    }
    
    func setUpConfiguration() {
        insetNumberStepper.value = originalEdgeInset
        cornerRadiusNumberStepper.value = originalEdgeCornerRadius
        
        shadowColorButton.backgroundColor = originalEdgeShadowColor
        backgroundColorButton.backgroundColor = originalEdgeBackgroundColor
        
        insetNumberStepper.numberStepperChanged = self
        cornerRadiusNumberStepper.numberStepperChanged = self
        
    }
    
}

extension EditingEdgesVC: NumberStepperChanged {
    func valueChanged(to value: Int, stepperType: NumberStepperType) {
        if stepperType == .edgeInset {
            editingEdgesChanged?.edgeInsetChanged(to: value)
        } else if stepperType == .edgeCornerRadius {
            editingEdgesChanged?.edgeCornerRadiusChanged(to: value)
        }
    }
}

extension EditingEdgesVC: ColorChanged {
    func colorChanged(color: UIColor, colorPickerType: ColorPickerType) {
        if colorPickerType == .edgeShadow {
            originalEdgeShadowColor = color
            shadowColorButton.backgroundColor = color
            editingEdgesChanged?.edgeShadowColorChanged(to: color)
        } else if colorPickerType == .edgeBackground {
            originalEdgeBackgroundColor = color
            backgroundColorButton.backgroundColor = color
            editingEdgesChanged?.backgroundColorChanged(to: color)
        }
    }
}
extension EditingEdgesVC: UIPopoverPresentationControllerDelegate {
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
}
