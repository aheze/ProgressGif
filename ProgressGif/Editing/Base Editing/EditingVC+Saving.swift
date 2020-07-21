//
//  EditingVC+Saving.swift
//  ProgressGif
//
//  Created by Zheng on 7/20/20.
//

import UIKit

extension EditingViewController {
    func saveConfig() {
        do {
            try realm.write {
                project?.configuration?.barHeight = editingConfiguration.barHeight
//                if let foregroundHex = editingConfiguration.barForegroundColor.toHex {
//                    project?.configuration?.barForegroundColorHex = foregroundHex
                    print("fore hex: \(editingConfiguration.barForegroundColorHex)")
//                }
//                if let backgroundHex = editingConfiguration.barBackgroundColor.toHex {
//                    project?.configuration?.barBackgroundColorHex = backgroundHex
                    print("back hex: \(editingConfiguration.barBackgroundColorHex)")
//                }
                project?.configuration?.barForegroundColorHex = editingConfiguration.barForegroundColorHex
                project?.configuration?.barBackgroundColorHex = editingConfiguration.barBackgroundColorHex
                
                project?.configuration?.edgeInset = editingConfiguration.edgeInset
                project?.configuration?.edgeCornerRadius = editingConfiguration.edgeCornerRadius
                project?.configuration?.edgeShadowIntensity = editingConfiguration.edgeShadowIntensity
                project?.configuration?.edgeShadowRadius = editingConfiguration.edgeShadowRadius
                
//                if let edgeShadowHex = editingConfiguration.edgeShadowColor.toHex {
//                    project?.configuration?.edgeShadowColorHex = edgeShadowHex
                    print("shadow hex: \(editingConfiguration.edgeShadowColorHex)")
//                }
                
                project?.configuration?.edgeShadowColorHex = editingConfiguration.edgeShadowColorHex
            }
        } catch {
            print("error adding object: \(error)")
        }
    }
    func loadConfig() {
        if let projectConfiguration = project?.configuration {
            editingConfiguration.barHeight = projectConfiguration.barHeight
            editingConfiguration.barForegroundColor = UIColor(hexString: projectConfiguration.barForegroundColorHex)
            editingConfiguration.barBackgroundColor = UIColor(hexString: projectConfiguration.barBackgroundColorHex)
            
            editingConfiguration.edgeInset = projectConfiguration.edgeInset
            editingConfiguration.edgeCornerRadius = projectConfiguration.edgeCornerRadius
            editingConfiguration.edgeShadowIntensity = projectConfiguration.edgeShadowIntensity
            editingConfiguration.edgeShadowRadius = projectConfiguration.edgeShadowRadius
            editingConfiguration.edgeShadowColor = UIColor(hexString: projectConfiguration.edgeShadowColorHex)
        }
    }
}
