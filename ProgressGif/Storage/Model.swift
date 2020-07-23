//
//  Model.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import RealmSwift

class Constants {
    
    /// divide the video height by this,
    /// then multiply this by the number stepper's value
    ///
    /// `var unit: CGFloat {`
    ///    `get {`
    ///        `return drawingView.frame.height / Constants.unitDivision`
    ///    `}`
    /// `}`
    static var unitDivision = CGFloat(75)
    
    /// multiply the number stepper's value by this, used for inset transform.
    /// inset itself is a value from 1-10, which needs to be shunken for scaling.
    ///
    /// `let scale = 1 - (CGFloat(inset) * transformMultiplier)`
    /// `playerBaseView.transform = CGAffineTransform(scaleX: scale, y: scale)`
    static var transformMultiplier = CGFloat(0.02)
    
    
    /// multiply the number stepper's value by this to get the shadow radius
    static var shadowRadiusMultiplier = CGFloat(0.5)
}

/// for realm
class Project: Object {
    @objc dynamic var dateCreated = Date()
    
    @objc dynamic var title = ""
    @objc dynamic var metadata: VideoMetadata?
    @objc dynamic var configuration: EditingConfiguration?
}
class VideoMetadata: Object {
    @objc dynamic var duration = "0:00"
    @objc dynamic var resolutionWidth = 500
    @objc dynamic var resolutionHeight = 500
    @objc dynamic var localIdentifier = ""
}
class EditingConfiguration: Object {
    @objc dynamic var barHeight = 5
    @objc dynamic var barForegroundColorHex = "FFB500"
    @objc dynamic var barBackgroundColorHex = "F4F4F4"
    
    @objc dynamic var edgeInset = 0
    @objc dynamic var edgeCornerRadius = 0
    @objc dynamic var edgeShadowIntensity = 0
    @objc dynamic var edgeShadowRadius = 0
    @objc dynamic var edgeShadowColorHex = "000000"
}


/// for editing
class EditableProject: NSObject {
    var dateCreated = Date()
    
    var title: String = ""
    var metadata = VideoMetadata()
    var configuration = EditingConfiguration()
}

class EditableVideoMetadata: NSObject {
    var duration: String = "0:00"
    var resolution: CGSize = CGSize(width: 500, height: 500)
    var localIdentifier: String = ""
}
class EditableEditingConfiguration: NSObject {
    var barHeight = 5
    var barForegroundColor = UIColor(named: "Yellorange")!
    var barBackgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    
    var barForegroundColorHex = "FFB500"
    var barBackgroundColorHex = "F4F4F4"
    
    var edgeInset = 0
    var edgeCornerRadius = 0
    var edgeShadowIntensity = 0
    var edgeShadowRadius = 0
    var edgeShadowColor = UIColor.black
    
    var edgeShadowColorHex = "000000"
//    var edgeBackgroundColor = UIColor.clear
}

/// FPS and scale coming in a later release
//enum FPS {
//    case frame5
//    case frame10
//    case frame15
//    case frame24
//    case frame30
//
//    func getInt() -> Int {
//        switch self {
//
//        case .frame5:
//            return 5
//        case .frame10:
//            return 10
//        case .frame15:
//            return 15
//        case .frame24:
//            return 24
//        case .frame30:
//            return 30
//        }
//    }
//}

