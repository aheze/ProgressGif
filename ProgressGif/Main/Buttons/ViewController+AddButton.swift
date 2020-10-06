//
//  ViewController+AddButton.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

extension ViewController {
    
    // MARK: - Animation for Add button
    
    func handleAddButtonTouchDown() {
        var transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        if addButtonIsPressed {
            transform = transform.rotated(by: -45.degreesToRadians)
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.addButton.transform = transform
        })
    }
    
    func handleAddButtonPress() {
        addButtonIsPressed.toggle()
        
        var transform = CGAffineTransform.identity
        if addButtonIsPressed {
            transform = transform.rotated(by: -45.degreesToRadians)
            showButtons()
        } else {
            hideButtons()
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.addButton.transform = transform
        })
    }
    
    func handleAddButtonTouchUpOutside() {
        var transform = CGAffineTransform.identity
        if addButtonIsPressed {
            transform = transform.rotated(by: -45.degreesToRadians)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.addButton.transform = transform
        })
    }
}
