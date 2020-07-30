//
//  SettingsVC+LoadValues.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

extension SettingsViewController {
    func loadValues() {
        barHeight = defaults.integer(forKey: "helpPressCount")
        barForegroundColorHex = defaults.string(forKey: "barForegroundColorHex") ?? "FFB500"
        barBackgroundColorHex = defaults.string(forKey: "barBackgroundColorHex") ?? "F4F4F4"
        
        edgeInset = defaults.integer(forKey: "edgeInset")
        edgeCornerRadius = defaults.integer(forKey: "edgeCornerRadius")
        edgeShadowIntensity = defaults.integer(forKey: "edgeShadowIntensity")
        edgeShadowColorHex = defaults.string(forKey: "edgeShadowColorHex") ?? "000000"
    }
}
