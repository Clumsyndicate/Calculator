//
//  ViewController.swift
//  Calculator
//
//  Created by Johnson Zhou on 14/08/2016.
//  Copyright © 2016 Johnson Zhou. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var textDisplay: UILabel!
    var formerBrain: CalculatorBrain?
    var brain = CalculatorBrain()

    var numberFormatter = NumberFormatter()
    
    
    var displayValue: Double? {
        get {
            if let string = textDisplay.text {
                if let value = Double(string) {
                    return value
                }
            }
            return nil
        }
        set {
            if let value = newValue {
                numberFormatter.alwaysShowsDecimalSeparator = false
                numberFormatter.maximumFractionDigits = 6
                textDisplay.text = numberFormatter.string(from: NSNumber(value: value))
            }
        }
    }
    
    var userInTheMiddleOfTyping = false
    var decimalPointAdded = false
    @IBAction func touchDigit(_ sender: UIButton) {
        if let appendingDigit = sender.currentTitle {
            if appendingDigit == "." {
                if decimalPointAdded {
                    return
                } else {
                    decimalPointAdded = true
                }
            }
            if userInTheMiddleOfTyping {
                textDisplay.text! += appendingDigit
            } else {
                textDisplay.text! = appendingDigit
                userInTheMiddleOfTyping = true
            }
        }
    }
    
    // entering a constant
    
    @IBAction func appendConstant(_ sender: UIButton) {
        
    }
    
    var userAtTheStartOfOperations = true
    @IBAction func performOperation(_ sender: UIButton) {
        formerBrain = brain
        if userInTheMiddleOfTyping {
            if let value = displayValue {
                brain.setOperand(value)
            // print("setOperand \(displayValue)")
            }
        }
        userInTheMiddleOfTyping = false     // an operation has started
        decimalPointAdded = false
        brain.performOperation(sender.currentTitle!)
        displayValue = brain.result
        if brain.isPartialResult {
            expressionLabel.text = brain.description + "..."
        } else {
            expressionLabel.text = brain.description + "="
        }
    }
    
    // transform between Degree and radian calculations

    @IBOutlet weak var DegRad: UIButton!
    @IBAction func DegRad(_ sender: UIButton) {
        brain.isDeg = !brain.isDeg
        if brain.isDeg {
            DegRad.setTitle("Deg", for: UIControlState())
        } else {
            DegRad.setTitle("Rad", for: UIControlState())
        }
    }
    
    // transform between Arc trigs and normal trigs
    
    @IBOutlet weak var sin: UIButton!
    @IBOutlet weak var cos: UIButton!
    @IBOutlet weak var tan: UIButton!
    @IBOutlet weak var cot: UIButton!
    fileprivate var isArc = false
    @IBAction func toArc(_ sender: UIButton) {
        if isArc {
            sin.setTitle("asin", for: UIControlState())
            cos.setTitle("acos", for: UIControlState())
            tan.setTitle("atan", for: UIControlState())
            cot.setTitle("acot", for: UIControlState())
        } else {
            sin.setTitle("sin", for: UIControlState())
            cos.setTitle("cos", for: UIControlState())
            tan.setTitle("tan", for: UIControlState())
            cot.setTitle("cot", for: UIControlState())
        }
    }
    
    // reset the calculator to its original form
    
    @IBAction func clear(_ sender: UIButton) {
        displayValue = 0
        expressionLabel.text = ""
        brain.clear()
    }
    @IBOutlet weak var expressionLabel: UILabel!
    @IBAction func backSpace(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            textDisplay.text?.remove(at: textDisplay.text!.index(before: textDisplay.text!.endIndex))
        } else {
            print(brain.program)
            brain.removeLastProgramObject()
            print(brain.program)
            brain.pendingBinary = nil
            brain.description = ""
            expressionLabel.text! = ""
            brain.program = brain.program
        }
    }
    
    var savedProgram: [AnyObject]?
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
        }
        displayValue = brain.result
        expressionLabel.text! = brain.description
    }
    
    
    @IBAction func setVariableOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            if let value = displayValue {
                brain.setVariableOperand(value)
                // print("setOperand \(displayValue)")
            }
        }
        userInTheMiddleOfTyping = false     // an operation has started
        decimalPointAdded = false
        brain.performOperation(sender.currentTitle!)
        print(brain.program)
        brain.program = brain.program
        displayValue = brain.result
    }

    
}

