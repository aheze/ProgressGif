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
    func colorChanged(color: UIColor, colorPickerType: ColorPickerType)
}

class ColorPickerViewController: UIViewController {
    
    var colorPickerType = ColorPickerType.barForeground
    @IBOutlet weak var colorPicker: ColorPicker!
    
    var originalColor = UIColor.yellow
    weak var colorChanged: ColorChanged?
    
    override func viewDidLoad() {
        
        colorPicker.addTarget(self, action: #selector(self.handleColorChanged(picker:)), for: .valueChanged)
        colorPicker.set(color: originalColor, colorSpace: .extendedSRGB)
        
        
    }
    
    @objc func handleColorChanged(picker: ColorPicker) {
//        print("change: \(picker.color)")
        colorChanged?.colorChanged(color: picker.color, colorPickerType: colorPickerType)
    }
    
}
