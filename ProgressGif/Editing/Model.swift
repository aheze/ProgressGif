//
//  Model.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

class Project: NSObject {
    var title: String = ""
    
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

class EditingConfiguration: NSObject {
    var barHeight = 5
    var barForegroundColor = UIColor(named: "Yellorange")!
    var barBackgroundColor = #colorLiteral(red: 0.9566580653, green: 0.9566580653, blue: 0.9566580653, alpha: 1)
    
    var edgeInset = 0
    var edgeCornerRadius = 0
    var edgeShadowIntensity = 0
    var edgeShadowRadius = 0
    var edgeShadowColor = UIColor.black
//    var edgeBackgroundColor = UIColor.clear
    
}
