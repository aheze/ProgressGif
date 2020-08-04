//
//  EditingVC+Drawing.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import UIKit

extension EditingViewController {
    
    func setUpDrawing(with configuration: EditableEditingConfiguration) {
        print("set up drawing...")
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
        
        transparentBackgroundImageView.alpha = 1
        shadowView.alpha = 1
        
        maskingView.isHidden = false
        playerBaseView.mask = maskingView
        
        setUpPreview()
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
//        print("calc asp")
        if let aspectFrame = imageView.getAspectFitRect() {
//            print("get aspect, \(aspectFrame)")
            imageAspectRect = aspectFrame
            
            drawingViewLeftC.constant = aspectFrame.origin.x
            drawingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            drawingViewTopC.constant = aspectFrame.origin.y
            drawingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
//            print("set up first consts")
            
            transparentBackgroundImageViewLeftC.constant = aspectFrame.origin.x
            transparentBackgroundImageViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            transparentBackgroundImageViewTopC.constant = aspectFrame.origin.y
            transparentBackgroundImageViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
//            print("set up second consts")
            
            shadowMaskingViewLeftC.constant = aspectFrame.origin.x
            shadowMaskingViewRightC.constant = (playerHolderView.frame.width - aspectFrame.width) / 2
            shadowMaskingViewTopC.constant = aspectFrame.origin.y
            shadowMaskingViewBottomC.constant = (playerHolderView.frame.height - aspectFrame.height) / 2
            
//            print("set up third consts")
            
            updateProgressBar(to: playerControlsView.customSlider.value, animated: true)
            
//            print("up prog")
            
            progressBarBackgroundHeightC.constant = CGFloat(editingConfiguration.barHeight) * unit
            
//            print("unit const")
            
            let scale = 1 - (CGFloat(editingConfiguration.edgeInset) * Constants.transformMultiplier)
            shadowScale = scale
            updateShadow(scale: scale)
            maskingView.frame = aspectFrame
            print("mask frame: \(aspectFrame)")
            
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
    
    func setUpPreview() {
        self.edgeCornerRadiusChangePreview(to: self.editingConfiguration.edgeCornerRadius, animate: true)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.barHeightChangePreview(to: self.editingConfiguration.barHeight)
            self.foregroundColorChangePreview(to: self.editingConfiguration.barForegroundColor)
            self.backgroundColorChangePreview(to: self.editingConfiguration.barBackgroundColor)
            
            self.edgeInsetChangePreview(to: self.editingConfiguration.edgeInset)
            
            self.edgeShadowIntensityChangePreview(to: self.editingConfiguration.edgeShadowIntensity)
            self.edgeShadowRadiusChangePreview(to: self.editingConfiguration.edgeShadowRadius)
            self.edgeShadowColorChangePreview(to: self.editingConfiguration.edgeShadowColor)
        })
    }
    
}
