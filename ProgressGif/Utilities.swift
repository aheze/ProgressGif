//
//  Utilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import AVFoundation

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

class ShadowView: UIView {

    var shouldActivate = false
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shouldActivate {
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
}
extension ShadowView {
    func updateShadow(rect: CGRect, radius: CGFloat) {
//        print("update, new rect: \(rect)")
        if let shadow = shadowLayer {
            shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
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

//class RoundedShadowImageView: UIView {
//
//    private var shadowLayer: CAShapeLayer!
//    private var imageView: UIImageView!
//    var image: UIImage?
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if imageView == nil {
//            let imageV = UIImageView()
//            imageV.frame = bounds
//            addSubview(imageV)
//
//        }
//
//
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2).cgPath
//            shadowLayer.fillColor = UIColor.white.cgColor
//
//            shadowLayer.shadowColor = UIColor.darkGray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//            shadowLayer.shadowOpacity = 0.4
//            shadowLayer.shadowRadius = 3
//
//            layer.insertSublayer(shadowLayer, at: 0)
//
//            if let image = self.image {
//                let drawingRect = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
//                print("drawingRect: \(drawingRect)")
//                let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
//                let mask = CAShapeLayer()
//                mask.path = path.cgPath
//                self.layer.mask = mask
//            }
//        }
//    }
//}

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
