//
//  SettingsVC+LoadValues.swift
//  ProgressGif
//
//  Created by Zheng on 7/30/20.
//

import UIKit

extension SettingsViewController {
    /// load default values
    func loadValues() {
        fpsString = defaults.string(forKey: DefaultKeys.fps) ?? FPS.normal.getString()
        
        barHeight = defaults.integer(forKey: DefaultKeys.barHeight)
        barForegroundColorHex = defaults.string(forKey: DefaultKeys.barForegroundColorHex) ?? "FFB500"
        barBackgroundColorHex = defaults.string(forKey: DefaultKeys.barBackgroundColorHex) ?? "F4F4F4"
        
        edgeInset = defaults.integer(forKey: DefaultKeys.edgeInset)
        edgeCornerRadius = defaults.integer(forKey: DefaultKeys.edgeCornerRadius)
        edgeShadowIntensity = defaults.integer(forKey: DefaultKeys.edgeShadowIntensity)
        edgeShadowRadius = defaults.integer(forKey: DefaultKeys.edgeShadowRadius)
        edgeShadowColorHex = defaults.string(forKey: DefaultKeys.edgeShadowColorHex) ?? "000000"
    }
}
