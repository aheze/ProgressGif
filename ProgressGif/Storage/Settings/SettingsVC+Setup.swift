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
        setUpFPSPicker()
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
    
    func setUpDisplayValues() {
        fpsButton.setTitle(fpsString.getFPS().getDescription(), for: .normal)
        
        heightNumberStepper.value = barHeight
        insetNumberStepper.value = edgeInset
        
        cornerRadiusNumberStepper.value = edgeCornerRadius
        shadowIntensityNumberStepper.value = edgeShadowIntensity
        shadowRadiusNumberStepper.value = edgeShadowRadius
        
        foregroundColorButton.backgroundColor =  UIColor(hexString: barForegroundColorHex)
        backgroundColorButton.backgroundColor =  UIColor(hexString: barBackgroundColorHex)
        shadowColorColorButton.backgroundColor =  UIColor(hexString: edgeShadowColorHex)
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
    
    
    func setUpFPSPicker() {
        
        pickerView.delegate = self
        fpsButton.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        
        toolBar.setItems([flexibleButton, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        fpsButton.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}
