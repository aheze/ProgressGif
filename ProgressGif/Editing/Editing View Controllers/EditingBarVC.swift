//
//  EditingBarVC.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

protocol EditingBarChanged: class {
    func barHeightChanged(to height: Int)
    func foregroundColorChanged(to color: UIColor)
    func backgroundColorChanged(to color: UIColor)
}

class EditingBarVC: UIViewController {
    
    weak var editingBarChanged: EditingBarChanged?
      
    var originalBarHeight = 5
    var originalBarForegroundColor = UIColor.yellow
    var originalBarBackgroundColor = UIColor.yellow
    
    @IBOutlet weak var heightBaseView: UIView!
    @IBOutlet weak var heightNumberStepper: NumberStepper!
    
    @IBOutlet weak var foregroundBaseView: UIView!
    @IBOutlet weak var foregroundColorButton: UIButton!
    @IBAction func foregroundColorPressed(_ sender: Any) {

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let popoverVC = storyboard.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
//        popoverVC.modalPresentationStyle = .popover
//        popoverVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 360)
//
//        popoverVC.originalColor = originalBarForegroundColor
//        popoverVC.colorChanged = self
//        popoverVC.colorPickerType = .barForeground
//
//        if let popoverController = popoverVC.popoverPresentationController {
//            popoverController.sourceView = foregroundColorButton
//            popoverController.sourceRect = foregroundColorButton.bounds
//            popoverController.permittedArrowDirections = .down
//            popoverController.delegate = self
//        }
//        present(popoverVC, animated: true, completion: nil)
        
        self.displayColorPicker(originalColor: originalBarForegroundColor, colorPickerType: .barForeground, sourceView: foregroundColorButton)
        
    }
    
    @IBOutlet weak var backgroundBaseView: UIView!
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    @IBAction func backgroundColorPressed(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let popoverVC = storyboard.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
//        popoverVC.modalPresentationStyle = .popover
//        popoverVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 360)
//
//        popoverVC.originalColor = originalBarBackgroundColor
//        popoverVC.colorChanged = self
//        popoverVC.colorPickerType = .barBackground
//
//        if let popoverController = popoverVC.popoverPresentationController {
//            popoverController.sourceView = backgroundColorButton
//            popoverController.sourceRect = backgroundColorButton.bounds
//            popoverController.permittedArrowDirections = .down
//            popoverController.delegate = self
//        }
//        present(popoverVC, animated: true, completion: nil)
        
        self.displayColorPicker(originalColor: originalBarBackgroundColor, colorPickerType: .barBackground, sourceView: backgroundColorButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightBaseView.layer.cornerRadius = 6
        foregroundBaseView.layer.cornerRadius = 6
        backgroundBaseView.layer.cornerRadius = 6
        
        foregroundColorButton.layer.cornerRadius = 6
        backgroundColorButton.layer.cornerRadius = 6
        
        setUpConfiguration()
    }
    
    func setUpConfiguration() {
        heightNumberStepper.value = originalBarHeight
        foregroundColorButton.backgroundColor = originalBarForegroundColor
        backgroundColorButton.backgroundColor = originalBarBackgroundColor
        
        heightNumberStepper.numberStepperChanged = self
    }
    
}

extension EditingBarVC: NumberStepperChanged {
    func valueChanged(to value: Int, stepperType: NumberStepperType) {
        editingBarChanged?.barHeightChanged(to: value)
    }
}

extension EditingBarVC: ColorChanged {
    func colorChanged(color: UIColor, colorPickerType: ColorPickerType) {
        if colorPickerType == .barForeground {
            originalBarForegroundColor = color
            foregroundColorButton.backgroundColor = color
            editingBarChanged?.foregroundColorChanged(to: color)
        } else if colorPickerType == .barBackground {
            originalBarBackgroundColor = color
            backgroundColorButton.backgroundColor = color
            editingBarChanged?.backgroundColorChanged(to: color)
        }
    }
}

extension EditingBarVC: UIPopoverPresentationControllerDelegate {
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
}


extension ColorChanged where Self: UIViewController, Self: UIPopoverPresentationControllerDelegate {
    func displayColorPicker(originalColor: UIColor, colorPickerType: ColorPickerType, sourceView: UIView) {
        print("Display!")
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
