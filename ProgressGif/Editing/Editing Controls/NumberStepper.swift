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
    
    /// for holding the button, which will file the timer rapidly
    weak var rapidLeftPressTimer: Timer?
    weak var rapidRightPressTimer: Timer?
    
    var shouldRapidLeft = false
    var shouldRapidRight = false
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    /// touch up inside, so cancel timers
    @IBAction func leftButtonPressed(_ sender: Any) {
//        print("left touch up inside")
        cancelTimers()
        if value - 1 >= 0 {
            value -= 1
            numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
        }
    }
    
    /// touch up inside, so cancel timers
    @IBAction func rightButtonPressed(_ sender: Any) {
//        print("right touch up inside")
        cancelTimers()
        value += 1
        numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
    }
    

    @objc func leftButtonDown(_ sender: UIButton) {
//        print("left touch down")
        cancelTimers()
        shouldRapidLeft = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.shouldRapidLeft {
                if self.rapidLeftPressTimer == nil {
                    self.rapidLeftPressTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.rapidLeftPress), userInfo: nil, repeats: true)
                }
            }
        })
    }

    /// touchUpOutside
    @objc func leftButtonUp(_ sender: UIButton) {
//        print("left touch up")
        cancelTimers()
    }
    @objc func rapidLeftPress() {
//        print("....rapid left")
        if self.shouldRapidLeft {
            if value - 1 >= 0 {
                value -= 1
                numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
            } else {
                cancelTimers()
            }
        } else {
            cancelTimers()
        }
    }
    
    @objc func rightButtonDown(_ sender: UIButton) {
        cancelTimers()
//        print("right touch down")
        shouldRapidRight = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.shouldRapidRight {
                if self.rapidRightPressTimer == nil {
                    self.rapidRightPressTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.rapidRightPress), userInfo: nil, repeats: true)
                }
            }
        })
    }

    /// touchUpOutside
    @objc func rightButtonUp(_ sender: UIButton) {
//        print("left touch up")
        cancelTimers()
    }
    @objc func rapidRightPress() {
//        print("....rapid right")
        if self.shouldRapidRight {
            value += 1
            numberStepperChanged?.valueChanged(to: value, stepperType: stepperType)
        } else {
            cancelTimers()
        }
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
        
        leftButton.addTarget(self, action: #selector(leftButtonDown), for: .touchDown)
        leftButton.addTarget(self, action: #selector(leftButtonUp), for: .touchUpOutside)
        
        rightButton.addTarget(self, action: #selector(rightButtonDown), for: .touchDown)
        rightButton.addTarget(self, action: #selector(rightButtonUp), for: .touchUpOutside)
    }
    
    func cancelTimers() {
//        print("cancel")
        shouldRapidLeft = false
        shouldRapidRight = false
        rapidLeftPressTimer?.invalidate()
        rapidLeftPressTimer = nil
        rapidRightPressTimer?.invalidate()
        rapidRightPressTimer = nil
    }
}
