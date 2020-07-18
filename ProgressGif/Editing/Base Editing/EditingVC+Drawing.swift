//
//  EditingVC+Drawing.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import UIKit

extension EditingViewController {
    
    func calculatePreviewScale() {
        if let videoResolution = actualVideoResolution {
            if videoResolution.width >= videoResolution.height {
                /// fatter
                self.percentageOfPreviewValue = self.playerHolderView.frame.width / videoResolution.width
            } else {
                self.percentageOfPreviewValue = self.playerHolderView.frame.height / videoResolution.height
            }
        }
    }
    
    func setUpDrawing(with configuration: EditingConfiguration) {
        
        let progressWidth = CGFloat(playerControlsView.customSlider.value) * progressBarFullWidth
        progressBarWidthC.constant = progressWidth
        
        progressBarBackgroundHeightC.constant = CGFloat(configuration.barHeight)
        progressBarBackgroundView.backgroundColor = configuration.barBackgroundColor
        progressBarView.backgroundColor = configuration.barForegroundColor
        
        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
        })
        
        
        /// setup the paging controllers
        editingBarVC?.heightNumberStepper.value = configuration.barHeight
        editingBarVC?.foregroundColorButton.backgroundColor = configuration.barForegroundColor
        editingBarVC?.backgroundColorButton.backgroundColor = configuration.barBackgroundColor
        
        editingEdgesVC?.insetNumberStepper.value = configuration.edgeInset
        editingEdgesVC?.cornerRadiusNumberStepper.value = configuration.edgeCornerRadius
        editingEdgesVC?.shadowColorButton.backgroundColor = configuration.edgeShadowColor
        
        
    }
    
    func updateProgressBar(to value: Float, animated: Bool) {
        let progressWidth = CGFloat(value) * progressBarFullWidth
        progressBarWidthC.constant = progressWidth
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.progressBarBackgroundView.layoutIfNeeded()
            })
        }
    }
    func calculateAspectDrawingFrame() {
        if let aspectFrame = imageView.getAspectFitRect() {
            
            drawingViewLeftC.constant = aspectFrame.origin.x
            drawingViewTopC.constant = aspectFrame.origin.y
            drawingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            drawingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            updateProgressBar(to: playerControlsView.customSlider.value, animated: true)
        }
    }
}
