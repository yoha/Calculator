//
//  ViewController.swift
//  Calculator
//
//  Created by Yohannes Wijaya on 8/29/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//
//
// tweak the significant digit logic.

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Stored Properties
    
    var isUserInTheMiddleOfTyping = false
    
    // var operandStack: [Double] = []
    var operandStack = Array<Double>()
    
    // MARK: - Computed Properties
    
    var displayValue: Double {
        get {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.usesSignificantDigits = true
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.maximumSignificantDigits = 3
            let formattedNumber = numberFormatter.numberFromString(self.displayLabel.text!)!.doubleValue
            return formattedNumber - floor(formattedNumber) < 0.01 ? formattedNumber : NSNumberFormatter().numberFromString(self.displayLabel.text!)!.doubleValue
        }
        set {
            self.displayLabel.text = newValue - floor(newValue) < 0.01 ? "\(newValue)" : String(format: "%.3f", newValue)
            self.isUserInTheMiddleOfTyping = false
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var historyDisplayLabel: UILabel!
    @IBOutlet weak var floatingPointButton: UIButton!
    
    // MARK: - IBAction Properties
    
    @IBAction func appendDigitButton(sender: UIButton) {
        if isUserInTheMiddleOfTyping {
            if self.displayLabel.text!.characters.first == "0" {
                if sender.currentTitle == "0" && self.displayLabel.text!.characters.contains(".") {
                    self.displayLabel.text! += sender.currentTitle!
                }
                else if self.displayLabel.text!.characters.contains(".") {
                    self.displayLabel.text! += sender.currentTitle!
                }
                else if sender.currentTitle! == "0" {
                    return
                }
                else {
                    self.displayLabel.text!.removeAtIndex(self.displayLabel.text!.startIndex)
                    self.displayLabel.text! += sender.currentTitle!
                }
            }
            else {
                if self.displayLabel.text!.characters.contains(".") {
                    self.floatingPointButton.enabled = false
                }
                self.displayLabel.text! += sender.currentTitle!
            }
        }
        else {
            self.displayLabel.text = sender.currentTitle!
            self.isUserInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func appendFloatingPointButton(sender: UIButton) {
        if self.displayLabel.text!.characters.contains(".") { return }
        else {
            self.displayLabel.text!.append("." as Character)
            self.floatingPointButton.enabled = false
            self.isUserInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func appendPieValue(sender: UIButton) {
        if self.operandStack.count == 0 {
            self.operandStack.append(self.displayValue)
            if self.operandStack.first == 0.0 {
                self.operandStack.removeAtIndex(self.operandStack.count - 1)
            }
        }
        self.displayValue = M_PI
        self.enterButton()
    }
    
    @IBAction func clearDisplayButton(sender: UIButton) {
        self.floatingPointButton.enabled = true
        self.displayLabel.text = "0"
        self.historyDisplayLabel.text = ""
        self.isUserInTheMiddleOfTyping = false
    }
    
    @IBAction func enterButton() {
        self.floatingPointButton.enabled = true
        self.isUserInTheMiddleOfTyping = false
        self.operandStack.append(self.displayValue)
        self.historyDisplayLabel.text! += "\(self.displayValue) "
        print("self.operandStack: \(operandStack)")
    }
    
    @IBAction func performMathOperationButton(sender: UIButton) {
        let calculationSymbol = sender.currentTitle!
        self.historyDisplayLabel.text! +=  "\(calculationSymbol) "
        
        if self.isUserInTheMiddleOfTyping { self.enterButton() }
        
        switch calculationSymbol {
            case "×": self.performMathCalculation({ (x: Double, y: Double) -> Double in return y * x })
            case "÷": self.performMathCalculation({ (x, y) in y / x }) // inference & implicit return
            case "+": self.performMathCalculation({ $1 + $0 }) // shorthand argument names
            case "−": self.performMathCalculation(){ $1 - $0 } // trailing closure for unary paramenter

            case "√": self.performMathCalculation { sqrt($0) } // () is unneeded for unary param
            
            case "sin": self.performMathCalculation({ (x: Double) -> Double in return sin(x) })
            case "cos": self.performMathCalculation({ x in cos(x) })
            case "tan": self.performMathCalculation({ tan($0) })
            default: break
        }
    }
    
    // MARK: - Custom Methods
    
    func performMathCalculation(operation: (x: Double, y: Double) -> Double) {
        guard self.operandStack.count >= 2 else { return }
        self.displayValue = operation(x: self.operandStack.removeLast(), y: self.operandStack.removeLast())
        self.enterButton()
    }

    @nonobjc // obj-c doesn't allow method overloading & this class inherits from UIViewController, which is an obj-c file despite writing it in swift.
    func performMathCalculation(operation: Double -> Double) {
        guard self.operandStack.count >= 1 else { return }
        self.displayValue = operation(self.operandStack.removeLast())
        self.enterButton()
    }
}

