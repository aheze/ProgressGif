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

enum FPS {
    case frame5
    case frame10
    case frame15
    case frame24
    case frame30
    
    func getInt() -> Int {
        switch self {
            
        case .frame5:
            return 5
        case .frame10:
            return 10
        case .frame15:
            return 15
        case .frame24:
            return 24
        case .frame30:
            return 30
        }
    }
}
class EditingConfiguration: NSObject {
    var barHeight = 5
    var barForegroundColor = UIColor.yellow
    var barBackgroundColor = UIColor.yellow
    
    var edgeInset = 0
    var edgeCornerRadius = 0
    var edgeShadowColor = UIColor.black
    var edgeBackgroundColor = UIColor.clear
    
    var optionsFPS = FPS.frame24
//    var optionsSc
}
