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
//        progressBarBackgroundHeightC.constant = CGFloat(height) * percentageOfPreviewValue
        progressBarBackgroundHeightC.constant = CGFloat(height) * unit
    }
    
    func foregroundColorChanged(to color: UIColor) {
        editingConfiguration.barForegroundColor = color
        progressBarView.backgroundColor = color
        
    }
    
    func backgroundColorChanged(to color: UIColor) {
        editingConfiguration.barBackgroundColor = color
        progressBarBackgroundView.backgroundColor = color
    }
}

extension EditingViewController: EditingEdgesChanged {
    func edgeShadowStateChanged(to isOn: Bool) {
        
    }
    
    func edgeInsetChanged(to inset: Int) {
        editingConfiguration.edgeInset = inset
        
        /// not using `unit` this time because transform scale is not dependent on the frame of the playerHolderView.
        /// transform values will automaitally adjust based on the size of the playerHolderView.
        let scale = 1 - (CGFloat(inset) * 0.02)
        playerBaseView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
    }
    func edgeCornerRadiusChanged(to radius: Int) {
        editingConfiguration.edgeCornerRadius = radius
        maskingView.layer.cornerRadius = (CGFloat(radius) * unit)
        
    }
    
    func edgeShadowColorChanged(to color: UIColor) {
        editingConfiguration.edgeShadowColor = color
        
    }
}
