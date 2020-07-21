//
//  EditingVC+EditingDelegates.swift
//  ProgressGif
//
//  Created by Zheng on 7/16/20.
//

import UIKit

extension EditingViewController: EditingBarChanged {
    func barHeightChanged(to height: Int) {
        editingConfiguration.barHeight = height
        progressBarBackgroundHeightC.constant = CGFloat(height) * unit
        saveConfig()
    }
    
    func foregroundColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.barForegroundColor = color
        editingConfiguration.barForegroundColorHex = hex
        progressBarView.backgroundColor = color
        saveConfig()
    }
    
    func backgroundColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.barBackgroundColor = color
        editingConfiguration.barBackgroundColorHex = hex
        progressBarBackgroundView.backgroundColor = color
        saveConfig()
    }
}

extension EditingViewController: EditingEdgesChanged {
    
    func edgeInsetChanged(to inset: Int) {
        editingConfiguration.edgeInset = inset
        
        /// not using `unit` this time because transform scale is not dependent on the frame of the playerHolderView.
        /// transform values will automaitally adjust based on the size of the playerHolderView.
        let scale = 1 - (CGFloat(inset) * 0.02)
        playerBaseView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        shadowScale = scale
        updateShadow(scale: scale)
        saveConfig()
    }
    func edgeCornerRadiusChanged(to radius: Int) {
        editingConfiguration.edgeCornerRadius = radius
        
        let previewRadius = CGFloat(radius) * unit
        maskingView.layer.cornerRadius = previewRadius
        shadowView.cornerRadius = previewRadius
        
        updateShadow(scale: shadowScale)
        saveConfig()
    }
    func edgeShadowIntensityChanged(to intensity: Int) {
        editingConfiguration.edgeShadowIntensity = intensity
        shadowView.intensity = intensity
        saveConfig()
    }
    func edgeShadowRadiusChanged(to radius: Int) {
        editingConfiguration.edgeShadowRadius = radius
        shadowView.shadowRadius = radius
        saveConfig()
    }
    func edgeShadowColorChanged(to color: UIColor, hex: String) {
        editingConfiguration.edgeShadowColor = color
        editingConfiguration.edgeShadowColorHex = hex
        shadowView.color = color
        updateShadow(scale: shadowScale)
        saveConfig()
    }
}
