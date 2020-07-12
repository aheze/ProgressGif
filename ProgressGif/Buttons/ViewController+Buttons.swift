//
//  ViewController+Buttons.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

extension ViewController {
    func showButtons() {
 
        
        self.importVideoBottomC.constant = importVideoBottomCShownConstant
        UIView.animate(withDuration: 0.6, animations: {
            self.importVideoLabel.alpha = 1
//            self.buttonContainerView.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.filesButton.transform = CGAffineTransform.identity
            self.filesButton.alpha = 1
        })
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.photosButton.transform = CGAffineTransform.identity
            self.photosButton.alpha = 1
        })
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.clipboardButton.transform = CGAffineTransform.identity
            self.clipboardButton.alpha = 1
        })
        
        
    }
    
    func hideButtons() {
        
        self.importVideoBottomC.constant = importVideoBottomCHiddenConstant
        UIView.animate(withDuration: 0.6, animations: {
            self.importVideoLabel.alpha = 0
//            self.buttonContainerView.alpha = 0
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.clipboardButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.clipboardButton.alpha = 0
        })
        UIView.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.photosButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.photosButton.alpha = 0
        })
        UIView.animate(withDuration: 0.1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.filesButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.filesButton.alpha = 0
        })
        
    }
    
    
}
