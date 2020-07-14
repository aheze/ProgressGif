//
//  Utilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import AVFoundation

extension UIViewController {
    func add(childViewController: UIViewController, inView: UIView) {
        // Add Child View Controller
        addChild(childViewController)

        // Add Child View as Subview
        inView.insertSubview(childViewController.view, at: 0)

        // Configure Child View
        childViewController.view.frame = self.view.bounds
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
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.4
                shadowLayer.shadowRadius = 3
//                
//                let maskLayer = CAShapeLayer()
//                maskLayer.frame = bounds
//                // Create the frame for the circle.
//                let radius: CGFloat = 6
//                // Rectangle in which circle will be drawn
//                let circlePath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
//                // Create a path
//                let path = UIBezierPath(rect: bounds)
//                // Append additional path which will create a circle
//                path.append(circlePath)
//                // Setup the fill rule to EvenOdd to properly mask the specified area and make a crater
//                maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
//                // Append the circle to the path so that it is subtracted.
//                maskLayer.path = path.cgPath
//                // Mask our view with Blue background so that portion of red background is visible
//                shadowLayer.mask = maskLayer

                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
}
extension ShadowView {
    func updateShadow(rect: CGRect, radius: CGFloat) {
//        print("update, new rect: \(rect)")
        if let shadow = shadowLayer {
            print("let shhaodw!")
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
class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}

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
