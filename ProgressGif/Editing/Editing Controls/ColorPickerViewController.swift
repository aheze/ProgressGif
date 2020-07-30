//
//  ColorPickerViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/16/20.
//

import UIKit
//import Colorful

enum ColorPickerType {
    case barForeground
    case barBackground
    case edgeShadow
    case edgeBackground
}
protocol ColorChanged: class {
    func colorChanged(color: UIColor, hexCode: String, colorPickerType: ColorPickerType)
}

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var colorPickerType = ColorPickerType.barForeground
    @IBOutlet weak var colorPicker: ColorPicker!
    
    var originalColor = UIColor.yellow
    weak var colorChanged: ColorChanged?
    
    override func viewDidLoad() {
        
        colorPicker.addTarget(self, action: #selector(self.handleColorChanged(picker:)), for: .valueChanged)
        colorPicker.set(color: originalColor, colorSpace: .extendedSRGB)
    }
    
    @objc func handleColorChanged(picker: ColorPicker) {
        colorChanged?.colorChanged(color: picker.color, hexCode: picker.hexColor, colorPickerType: colorPickerType)
    }
    
}

extension ColorChanged where Self: UIViewController, Self: UIPopoverPresentationControllerDelegate {
    func displayColorPicker(originalColor: UIColor, colorPickerType: ColorPickerType, sourceView: UIView) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyboard.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        
        popoverVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 360)
        
        popoverVC.originalColor = originalColor
        popoverVC.colorChanged = self
        popoverVC.colorPickerType = colorPickerType
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = .down
            popoverController.delegate = self
        }
        
        present(popoverVC, animated: true, completion: nil)
        
    }
}
