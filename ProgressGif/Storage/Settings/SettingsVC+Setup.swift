//
//  SettingsVC+Setup.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

extension SettingsViewController {
    
    func setUp() {
        loadValues()
        
        setUpDelegates()
        setUpDisplayValues()
        setUpCornerRadius()
    }
    func setUpDelegates() {
        
        heightNumberStepper.numberStepperChanged = self
        insetNumberStepper.numberStepperChanged = self
        cornerRadiusNumberStepper.numberStepperChanged = self
        shadowIntensityNumberStepper.numberStepperChanged = self
        shadowRadiusNumberStepper.numberStepperChanged = self
        
        /// set up stepper type
        heightNumberStepper.stepperType = .barHeight
        insetNumberStepper.stepperType = .edgeInset
        cornerRadiusNumberStepper.stepperType = .edgeCornerRadius
        shadowIntensityNumberStepper.stepperType = .edgeShadowIntensity
        shadowRadiusNumberStepper.stepperType = .edgeShadowRadius
    }
    
    func setUpCornerRadius() {
        
        generalBaseView.layer.cornerRadius = 8
        defaultBarValuesBaseView.layer.cornerRadius = 8
        defaultEdgeValuesBaseView.layer.cornerRadius = 8
        
        fpsView.layer.cornerRadius = 6
        fpsButton.layer.cornerRadius = 6
        
        heightView.layer.cornerRadius = 6
        foregroundView.layer.cornerRadius = 6
        backgroundView.layer.cornerRadius = 6
        
        foregroundColorButton.layer.cornerRadius = 6
        backgroundColorButton.layer.cornerRadius = 6
        
        foregroundColorButton.addBorder(width: 3, color: UIColor.lightGray)
        backgroundColorButton.addBorder(width: 3, color: UIColor.lightGray)
        
        
        insetView.layer.cornerRadius = 6
        cornerRadiusView.layer.cornerRadius = 6
        shadowIntensityView.layer.cornerRadius = 6
        shadowRadiusView.layer.cornerRadius = 6
        shadowColorView.layer.cornerRadius = 6
        
        shadowColorColorButton.layer.cornerRadius = 6
        shadowColorColorButton.addBorder(width: 3, color: UIColor.lightGray)
    }
    
    func setUpDisplayValues() {
        heightNumberStepper.value = barHeight
        insetNumberStepper.value = edgeInset
        
        cornerRadiusNumberStepper.value = edgeCornerRadius
        shadowIntensityNumberStepper.value = edgeShadowIntensity
        shadowRadiusNumberStepper.value = edgeShadowRadius
        
        foregroundColorButton.backgroundColor =  UIColor(hexString: barForegroundColorHex)
        backgroundColorButton.backgroundColor =  UIColor(hexString: barBackgroundColorHex)
        shadowColorColorButton.backgroundColor =  UIColor(hexString: edgeShadowColorHex)
    }
}
