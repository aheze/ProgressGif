//
//  Utilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import AVFoundation

// MARK: - A bunch of random utilities.

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

/// for the FPS picker
/// allow a toolbar to be added to the picker
class InputViewButton: UIButton {
    var viewForInput = UIView()
    var toolBarView = UIView()
    
    override var inputView: UIView {
        get {
            return self.viewForInput
        }

        set {
            self.viewForInput = newValue
        }
    }
    
    override var inputAccessoryView: UIView {
        get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension UIView {
    func animateCornerRadius(to: CGFloat, duration: CFTimeInterval) {
        let initialCornerRadius = layer.cornerRadius
        
        CATransaction.begin()
        layer.cornerRadius = to
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = initialCornerRadius
        animation.toValue = to
        animation.duration = duration
        layer.add(animation, forKey: "cornerRadius")
        CATransaction.commit()
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UIColor {
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

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
        
        // Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
}

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat) -> CGRect? {
        if let image = self.image {
            let drawingRect = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
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
                shadowLayer.fillColor = ColorCompatibility.systemFill.cgColor
                
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
            shadowLayer.fillColor = ColorCompatibility.systemBackground.cgColor
            
            shadowLayer.shadowColor = ColorCompatibility.secondaryLabel.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        shadowLayer.fillColor = ColorCompatibility.systemBackground.cgColor
        shadowLayer.shadowColor = ColorCompatibility.secondaryLabel.cgColor
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
