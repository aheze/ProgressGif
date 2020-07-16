//
//  Setup.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

extension ViewController {
    
    
    
    func setUpButtonAlpha() {
        filesButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        filesButton.alpha = 0
        photosButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        photosButton.alpha = 0
        clipboardButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        clipboardButton.alpha = 0
        
        importVideoLabel.alpha = 0
        importVideoBottomC.constant = importVideoBottomCHiddenConstant
        
//        buttonContainerView.alpha = 0
    }
}
