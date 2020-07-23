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
                self.percentageOfPreviewValue = CGFloat(videoResolution.width) / self.playerHolderView.frame.width
            } else {
                self.percentageOfPreviewValue = CGFloat(videoResolution.height) / self.playerHolderView.frame.height
            }
        }
    }
    
    func setUpDrawing(with configuration: EditableEditingConfiguration) {
        let progressWidth = CGFloat(playerControlsView.customSlider.value) * progressBarFullWidth
        progressBarWidthC.constant = progressWidth
        
        progressBarBackgroundHeightC.constant = CGFloat(configuration.barHeight) * unit
        progressBarBackgroundView.backgroundColor = configuration.barBackgroundColor
        progressBarView.backgroundColor = configuration.barForegroundColor
        
        UIView.animate(withDuration: 0.6, animations: {
            self.progressBarBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        /// setup the paging controllers
        editingBarVC?.heightNumberStepper.value = configuration.barHeight
        editingBarVC?.foregroundColorButton.backgroundColor = configuration.barForegroundColor
        editingBarVC?.backgroundColorButton.backgroundColor = configuration.barBackgroundColor
        
        editingEdgesVC?.insetNumberStepper.value = configuration.edgeInset
        editingEdgesVC?.cornerRadiusNumberStepper.value = configuration.edgeCornerRadius
        editingEdgesVC?.shadowColorButton.backgroundColor = configuration.edgeShadowColor
        
        maskingView.isHidden = false
        playerBaseView.mask = maskingView
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
            imageAspectRect = aspectFrame
            
            drawingViewLeftC.constant = aspectFrame.origin.x
            drawingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            drawingViewTopC.constant = aspectFrame.origin.y
            drawingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            
            transparentBackgroundImageViewLeftC.constant = aspectFrame.origin.x
            transparentBackgroundImageViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            transparentBackgroundImageViewTopC.constant = aspectFrame.origin.y
            transparentBackgroundImageViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            shadowMaskingViewLeftC.constant = aspectFrame.origin.x
            shadowMaskingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            shadowMaskingViewTopC.constant = aspectFrame.origin.y
            shadowMaskingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            maskingView.frame = aspectFrame
            
            updateProgressBar(to: playerControlsView.customSlider.value, animated: true)
            progressBarBackgroundHeightC.constant = CGFloat(editingConfiguration.barHeight) * unit
            maskingView.layer.cornerRadius = (CGFloat(editingConfiguration.edgeCornerRadius) * unit)
            
            let scale = 1 - (CGFloat(editingConfiguration.edgeInset) * Constants.transformMultiplier)
            shadowScale = scale
            updateShadow(scale: scale)
            
        }
    }
    
    func updateShadow(scale: CGFloat) {
        let adjustedShadowWidth = imageAspectRect.width * scale
        let adjustedShadowHeight = imageAspectRect.height * scale
        let adjustedShadowRect = CGRect(x: (imageAspectRect.width - adjustedShadowWidth) / 2,
                                        y: (imageAspectRect.height - adjustedShadowHeight) / 2,
                                        width: adjustedShadowWidth,
                                        height: adjustedShadowHeight)
        
        shadowView.frame = adjustedShadowRect
        shadowView.updateShadow()
    }
}
