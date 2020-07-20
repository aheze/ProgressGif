//
//  Utilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import AVFoundation

extension UIView {
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UIViewController {
    func add(childViewController: UIViewController, inView: UIView) {
        // Add Child View Controller
        addChild(childViewController)

        // Add Child View as Subview
        inView.insertSubview(childViewController.view, at: 0)

        // Configure Child View
        childViewController.view.frame = inView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        print("adding view controller")
        // Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
}

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat) -> CGRect? {
        if let image = self.image {
            let drawingRect = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
//            print("drawingRect: \(drawingRect)")
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
            return drawingRect
        } else {
            return nil
        }
    }
}

extension UIImageView {
    func getAspectFitRect() -> CGRect? {
        if let image = self.image {
            let drawingRect = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
            return drawingRect
        } else {
            return nil
        }
    }
}

/// for the collectionview. The shadow for the editing preview is in DropShadow.swift
class ShadowView: UIView {

    var shouldActivate = false
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shouldActivate {
            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2).cgPath
                shadowLayer.fillColor = UIColor.systemFill.cgColor

                shadowLayer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
                shadowLayer.shadowOpacity = 0.4
                shadowLayer.shadowRadius = 3
                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
}

extension ShadowView {
    func updateShadow(rect: CGRect, radius: CGFloat) {
        if let shadow = shadowLayer {
            shadow.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
            shadow.shadowPath = shadow.path
        }
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

/// button with shadow (for importing)
class CustomButton: UIButton {
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 3

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

/// for the video playback
class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}

/// for the import buttons
extension UIView {
    func scaleDown() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    func scaleUp() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
