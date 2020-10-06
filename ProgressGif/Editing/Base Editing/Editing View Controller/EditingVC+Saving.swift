//
//  EditingVC+Saving.swift
//  ProgressGif
//
//  Created by Zheng on 7/20/20.
//

import UIKit

// MARK: - the title at the top of the screen
extension EditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveConfig()
        return true
    }
}

// MARK: - called whenever a value changes
extension EditingViewController {
    func saveConfig() {
        do {
            try realm.write {
                
                project?.title = titleTextField.text ?? "Untitled"
                
                project?.configuration?.barHeight = editingConfiguration.barHeight
                project?.configuration?.barForegroundColorHex = editingConfiguration.barForegroundColorHex
                project?.configuration?.barBackgroundColorHex = editingConfiguration.barBackgroundColorHex
                
                project?.configuration?.edgeInset = editingConfiguration.edgeInset
                project?.configuration?.edgeCornerRadius = editingConfiguration.edgeCornerRadius
                project?.configuration?.edgeShadowIntensity = editingConfiguration.edgeShadowIntensity
                project?.configuration?.edgeShadowRadius = editingConfiguration.edgeShadowRadius
                project?.configuration?.edgeShadowColorHex = editingConfiguration.edgeShadowColorHex
            }
        } catch {
            print("error adding object: \(error)")
        }
    }
    
    /// load all values from a saved project
    func loadConfig() {
        if let projectConfiguration = project?.configuration {
            editingConfiguration.barHeight = projectConfiguration.barHeight
            editingConfiguration.barForegroundColor = UIColor(hexString: projectConfiguration.barForegroundColorHex)
            editingConfiguration.barForegroundColorHex = projectConfiguration.barForegroundColorHex
            editingConfiguration.barBackgroundColor = UIColor(hexString: projectConfiguration.barBackgroundColorHex)
            editingConfiguration.barBackgroundColorHex = projectConfiguration.barBackgroundColorHex
            
            editingConfiguration.edgeInset = projectConfiguration.edgeInset
            editingConfiguration.edgeCornerRadius = projectConfiguration.edgeCornerRadius
            editingConfiguration.edgeShadowIntensity = projectConfiguration.edgeShadowIntensity
            editingConfiguration.edgeShadowRadius = projectConfiguration.edgeShadowRadius
            editingConfiguration.edgeShadowColor = UIColor(hexString: projectConfiguration.edgeShadowColorHex)
            editingConfiguration.edgeShadowColorHex = projectConfiguration.edgeShadowColorHex
        }
    }
}
