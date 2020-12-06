//
//  EditingVC+Drawing.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import UIKit

// MARK: - Set up the live preview
/// The live preview is pretty simple.
/// Instead of actively rendering the video to add a progress bar each time a value changes (that would take too much processing power)...
/// I recreate the progress bar using `UIView`s. That's it!
/// over the video player, there's a `drawingView`
/// inside here is where all the overlays get added!

/// This file contains a lot of live-preview drawing-related code!


extension EditingViewController {
    
    /// called when the transition to `editingViewController` is done:
    /// from Files: `FromFiles.swift`, line 99
    /// from Photos: `PopAnimator.swift`, line 85
    /// from Pasting URL: `PasteVC+Present.swift`, line 88
    
    /// this function sets up the live preview with values from the configuration
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
        if let aspectFrame = imageView.getAspectFitRect() {
            
            guard
                !aspectFrame.origin.x.isNaN,
                !aspectFrame.origin.y.isNaN,
                !aspectFrame.width.isNaN,
                !aspectFrame.height.isNaN
                else {
                    print("has nan value!!")
                    return
            }
            
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
            
            updateProgressBar(to: playerControlsView.customSlider.value, animated: true)
            
            progressBarBackgroundHeightC.constant = CGFloat(editingConfiguration.barHeight) * unit
            
            let scale = 1 - (CGFloat(editingConfiguration.edgeInset) * Constants.transformMultiplier)
            shadowScale = scale
            updateShadow(scale: scale)
            maskingView.frame = aspectFrame
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
