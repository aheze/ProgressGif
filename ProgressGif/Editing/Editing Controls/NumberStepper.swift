//
//  NumberStepper.swift
//  ProgressGif
//
//  Created by Zheng on 7/16/20.
//

import UIKit

// for the delegate
enum NumberStepperType {
    case barHeight
    case edgeInset
    case edgeCornerRadius
}

protocol NumberStepperChanged: class {
    func valueChanged(to value: Int, stepperType: NumberStepperType)
}
class NumberStepper: UIView {
    
    var stepperType = NumberStepperType.barHeight
    var value = 5 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }
    weak var numberStepperChanged: NumberStepperChanged?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if value - 1 >= 0 {
            value -= 1
            numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        value += 1
        numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
    }
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NumberStepper", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        valueLabel.text = "\(value)"
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
    }
}
