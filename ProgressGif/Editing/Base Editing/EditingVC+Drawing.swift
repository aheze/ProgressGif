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
        print("setup")
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
            
//            print("playerHolder frame: \(playerHolderView.frame)")
//            print("playerBase frame: \(playerBaseView.frame)")
//            print("drawingview frame: \(drawingView.frame)")
//            print("maskingview frame: \(maskingView.frame)")
            
            drawingViewLeftC.constant = aspectFrame.origin.x
            drawingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            drawingViewTopC.constant = aspectFrame.origin.y
            drawingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            
            transparentBackgroundImageViewLeftC.constant = aspectFrame.origin.x
            transparentBackgroundImageViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            transparentBackgroundImageViewTopC.constant = aspectFrame.origin.y
            transparentBackgroundImageViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
            maskingView.frame = aspectFrame
//            maskingViewLeftC.constant = aspectFrame.origin.x
//            maskingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
//            maskingViewTopC.constant = aspectFrame.origin.y
//            maskingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
//            print("new frames drawing: \(drawingView.frame)")
//            print("new frames masking: \(maskingView.frame)")
//            print("bar height 1: \(progressBarBackgroundView.frame)")
            updateProgressBar(to: playerControlsView.customSlider.value, animated: true)
            progressBarBackgroundHeightC.constant = CGFloat(editingConfiguration.barHeight) * unit
            maskingView.layer.cornerRadius = (CGFloat(editingConfiguration.edgeCornerRadius) * unit)
            
//            print("bar height 2: \(progressBarBackgroundView.frame)")
        }
    }
}
