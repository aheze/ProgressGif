//
//  EditingViewController+EditingDelegates.swift
//  ProgressGif
//
//  Created by Zheng on 7/16/20.
//

import UIKit

extension EditingViewController: EditingBarChanged {
    func barHeightChanged(to height: Int) {
        editingConfiguration.barHeight = height
        progressBarBackgroundHeightC.constant = CGFloat(height)
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
    func edgeInsetChanged(to inset: Int) {
        editingConfiguration.edgeInset = inset
        
    }
    func edgeCornerRadiusChanged(to radius: Int) {
        editingConfiguration.edgeCornerRadius = radius
    }
    
    func edgeShadowColorChanged(to color: UIColor) {
        editingConfiguration.edgeShadowColor = color
        
    }
}
