//
//  SettingsVC+EditingDelegates.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

/// Delegates from the steppers/pickers
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fpsOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fpsOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedFPS = fpsOptionList[row]
        let fpsDescription = selectedFPS.getDescription()
        fpsString = selectedFPS.getString()
        
        defaults.set(fpsString, forKey: DefaultKeys.fps)
        DispatchQueue.main.async {
            self.fpsButton.setTitle(fpsDescription, for: .normal)
        }
    }
}

extension SettingsViewController: NumberStepperChanged {
    func valueChanged(to value: Int, stepperType: NumberStepperType) {
        switch stepperType {
        case .barHeight:
            defaults.set(value, forKey: DefaultKeys.barHeight)
        case .edgeInset:
            defaults.set(value, forKey: DefaultKeys.edgeInset)
        case .edgeCornerRadius:
            defaults.set(value, forKey: DefaultKeys.edgeCornerRadius)
        case .edgeShadowIntensity:
            defaults.set(value, forKey: DefaultKeys.edgeShadowIntensity)
        case .edgeShadowRadius:
            defaults.set(value, forKey: DefaultKeys.edgeShadowRadius)
        }
    }
}

extension SettingsViewController: ColorChanged {
    func colorChanged(color: UIColor, hexCode: String, colorPickerType: ColorPickerType) {
        switch colorPickerType {
        case .barForeground:
            foregroundColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: DefaultKeys.barForegroundColorHex)
        case .barBackground:
            backgroundColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: DefaultKeys.barBackgroundColorHex)
        case .edgeShadow:
            shadowColorColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: DefaultKeys.edgeShadowColorHex)
        case .edgeBackground: /// add in later release
            break
        }
    }
}

extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
}
