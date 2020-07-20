//
//  DropShadow.swift
//  ProgressGif
//
//  Created by Zheng on 7/19/20.
//

import UIKit

class ResizableShadowView: UIView {
    var cornerRadius = CGFloat(0) {
        didSet {
            updateShadow()
        }
    }
    var color = UIColor.black {
        didSet {
            updateShadow()
        }
    }
    var intensity = Int(1) {
        didSet {
            updateShadow()
        }
    }
    var shadowRadius = Int(1) {
        didSet {
            print("radius")
            updateShadow()
        }
    }
    func updateShadow() {
        layer.shadowColor = color.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = min(Float(intensity) / 10, 1) /// the stepper limit is 10, but this is just in case.
        layer.shadowRadius = CGFloat(shadowRadius) * 0.5
    }
}
