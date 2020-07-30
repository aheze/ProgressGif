//
//  SettingsVC+EditingDelegates.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

extension SettingsViewController: NumberStepperChanged {
    func valueChanged(to value: Int, stepperType: NumberStepperType) {
        switch stepperType {
        case .barHeight:
            defaults.set(value, forKey: "barHeight")
        case .edgeInset:
            defaults.set(value, forKey: "edgeInset")
        case .edgeCornerRadius:
            defaults.set(value, forKey: "edgeCornerRadius")
        case .edgeShadowIntensity:
            defaults.set(value, forKey: "edgeShadowIntensity")
        case .edgeShadowRadius:
            defaults.set(value, forKey: "edgeShadowRadius")
        }
    }
}

extension SettingsViewController: ColorChanged {
    func colorChanged(color: UIColor, hexCode: String, colorPickerType: ColorPickerType) {
        switch colorPickerType {
        case .barForeground:
            foregroundColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: "barForegroundColorHex")
        case .barBackground:
            backgroundColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: "barBackgroundColorHex")
        case .edgeShadow:
            shadowColorColorButton.backgroundColor = color
            defaults.set(hexCode, forKey: "edgeShadowColorHex")
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

//extension SettingsViewController: EditingBarChanged {
//    func barHeightChanged(to height: Int) {
//        defaults.set(height, forKey: "barHeight")
//    }
//
//    func foregroundColorChanged(to color: UIColor, hex: String) {
//        defaults.set(hex, forKey: "barForegroundColorHex")
//    }
//
//    func backgroundColorChanged(to color: UIColor, hex: String) {
//        defaults.set(hex, forKey: "barBackgroundColorHex")
//    }
//}
//
//extension SettingsViewController: EditingEdgesChanged {
//
//    func edgeInsetChanged(to inset: Int) {
//        defaults.set(inset, forKey: "edgeInset")
//    }
//    func edgeCornerRadiusChanged(to radius: Int) {
//        defaults.set(radius, forKey: "edgeCornerRadius")
//    }
//    func edgeShadowIntensityChanged(to intensity: Int) {
//        defaults.set(intensity, forKey: "edgeShadowIntensity")
//    }
//    func edgeShadowRadiusChanged(to radius: Int) {
//        defaults.set(radius, forKey: "edgeShadowRadius")
//    }
//    func edgeShadowColorChanged(to color: UIColor, hex: String) {
//        defaults.set(hex, forKey: "edgeShadowColorHex")
//    }
//}
