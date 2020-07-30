//
//  EditingVC+EditingDelegates.swift
//  ProgressGif
//
//  Created by Zheng on 7/16/20.
//

import UIKit

extension Int {
    
    /// use this on the Number Stepper's value for bar height
    func getBarHeightFromValue(withUnit: CGFloat) -> CGFloat {
        let height = CGFloat(self) * withUnit
        return height
    }
    
    /// use this on the Number Stepper's value for edge insets
    func getScaleFromInsetValue() -> CGFloat {
        let scale = 1 - (CGFloat(self) * Constants.transformMultiplier)
        return scale
    }
    
    /// use this on the Number Stepper's value for rounded corners
    func getRadiusFromValue(withUnit: CGFloat) -> CGFloat {
        let radius = CGFloat(self) * withUnit
        return radius
    }
    
    /// use this on the Number Stepper's value for shadows (not rounded corners)
    func getShadowRadiusFromValue(withUnit: CGFloat) -> CGFloat {
        let radius = (CGFloat(self) * withUnit) / 2
        return radius
    }
    
}

extension EditingViewController {
    func barHeightChangePreview(to height: Int) {
        progressBarBackgroundHeightC.constant = height.getBarHeightFromValue(withUnit: unit)
    }
    func foregroundColorChangePreview(to color: UIColor) {
        progressBarView.backgroundColor = color
    }
    func backgroundColorChangePreview(to color: UIColor) {
        progressBarBackgroundView.backgroundColor = color
    }
    
    func edgeInsetChangePreview(to inset: Int) {
        let scale = inset.getScaleFromInsetValue()
        playerBaseView.transform = CGAffineTransform(scaleX: scale, y: scale)
        updateShadow(scale: scale)
        shadowScale = scale
    }
    func edgeCornerRadiusChangePreview(to radius: Int, animate: Bool = false) {
        print("corner change")
        
        let previewRadius = radius.getRadiusFromValue(withUnit: unit)
        if animate {
            maskingView.animateCornerRadius(to: previewRadius, duration: 0.5)
        } else {
            maskingView.layer.cornerRadius = previewRadius
        }
        shadowView.cornerRadius = previewRadius
        updateShadow(scale: shadowScale)
    }
    func edgeShadowIntensityChangePreview(to intensity: Int) {
        shadowView.intensity = intensity
    }
    func edgeShadowRadiusChangePreview(to radius: Int) {
        let shadowRadius = radius.getShadowRadiusFromValue(withUnit: unit)
        shadowView.shadowRadius = Int(shadowRadius)
    }
    func edgeShadowColorChangePreview(to color: UIColor) {
        shadowView.color = color
        updateShadow(scale: shadowScale)
    }
}

extension EditingViewController: EditingBarChanged {
    func barHeightChanged(to height: Int) {
        editingConfiguration.barHeight = height
//        progressBarBackgroundHeightC.constant = height.getBarHeightFromValue(withUnit: unit)
        barHeightChangePreview(to: height)
        saveConfig()
    }
    
    func foregroundColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.barForegroundColor = color
        editingConfiguration.barForegroundColorHex = hex
//        progressBarView.backgroundColor = color
        foregroundColorChangePreview(to: color)
        saveConfig()
    }
    
    func backgroundColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.barBackgroundColor = color
        editingConfiguration.barBackgroundColorHex = hex
//        progressBarBackgroundView.backgroundColor = color
        backgroundColorChangePreview(to: color)
        saveConfig()
    }
}

extension EditingViewController: EditingEdgesChanged {
    
    func edgeInsetChanged(to inset: Int) {
        editingConfiguration.edgeInset = inset
        
        /// not using `unit` this time because transform scale is not dependent on the frame of the playerHolderView.
        /// transform values will automaitally adjust based on the size of the playerHolderView.
//        let scale = 1 - (CGFloat(inset) * Constants.transformMultiplier)
        
//        let scale = inset.getScaleFromInsetValue()
//        playerBaseView.transform = CGAffineTransform(scaleX: scale, y: scale)
//        updateShadow(scale: scale)
//        shadowScale = scale
        
        edgeInsetChangePreview(to: inset)
        
        saveConfig()
    }
    func edgeCornerRadiusChanged(to radius: Int) {
        editingConfiguration.edgeCornerRadius = radius
        
//        let previewRadius = radius.getRadiusFromValue(withUnit: unit)
//        maskingView.layer.cornerRadius = previewRadius
//        shadowView.cornerRadius = previewRadius
//        updateShadow(scale: shadowScale)
        
        edgeCornerRadiusChangePreview(to: radius)
        
        saveConfig()
    }
    func edgeShadowIntensityChanged(to intensity: Int) {
        editingConfiguration.edgeShadowIntensity = intensity
//        shadowView.intensity = intensity
        
        edgeShadowIntensityChangePreview(to: intensity)
        saveConfig()
    }
    func edgeShadowRadiusChanged(to radius: Int) {
        editingConfiguration.edgeShadowRadius = radius
        
//        let shadowRadius = radius.getShadowRadiusFromValue(withUnit: unit)
//        shadowView.shadowRadius = Int(shadowRadius)
        
        edgeShadowRadiusChangePreview(to: radius)
        
        saveConfig()
    }
    func edgeShadowColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.edgeShadowColor = color
        editingConfiguration.edgeShadowColorHex = hex
//        shadowView.color = color
//        updateShadow(scale: shadowScale)
        edgeShadowColorChangePreview(to: color)
        saveConfig()
    }
}
