//
//  ViewController.swift
//  Calculator
//
//  Created by Yohannes Wijaya on 8/29/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DigitZeroButton.enabled = false
    }
    
    // MARK: - Stored Properties
    
    var userIsInTheMiddleOfTypingNumber = false
    
    // var operandStack: [Double] = []
    var operandStack = Array<Double>()
    
    // MARK: - Computed Properties
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(self.displayLabel.text!)!.doubleValue
        }
        set {
            self.displayLabel.text = "\(newValue)"
            self.userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var DigitZeroButton: UIButton!
    @IBOutlet weak var floatingPointButton: UIButton!
    
    // MARK: - IBAction Properties
    
    @IBAction func appendDigitButtonPressed(sender: UIButton) {
        self.DigitZeroButton.enabled = true
        
        if userIsInTheMiddleOfTypingNumber {
            self.displayLabel.text! += sender.currentTitle!
        }
        else {
            self.displayLabel.text = sender.currentTitle!
            self.userIsInTheMiddleOfTypingNumber = true
        }
    }
    @IBAction func clearDisplayButtonPressed(sender: UIButton) {
        self.DigitZeroButton.enabled = false
        self.floatingPointButton.enabled = true
        self.displayLabel.text = "0"
        self.userIsInTheMiddleOfTypingNumber = false
    }
    
    @IBAction func floatingPointButtonPressed(sender: UIButton) {
        self.DigitZeroButton.enabled = true
        if self.displayLabel.text!.characters.contains(".") { return }
        else {
            self.displayLabel.text!.append("." as Character)
            self.floatingPointButton.enabled = false
            self.userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func enterButtonPressed() {
        self.DigitZeroButton.enabled = true
        self.floatingPointButton.enabled = true
        self.userIsInTheMiddleOfTypingNumber = false
        self.operandStack.append(self.displayValue)
        
        print("self.operandStack: \(operandStack)")
    }
    
    @IBAction func calculateButtonPressed(sender: UIButton) {
        let calculationSymbol = sender.currentTitle
        
        if self.userIsInTheMiddleOfTypingNumber { self.enterButtonPressed() }
        
        switch calculationSymbol! {
            case "×": self.performMathCalculation({ (x: Double, y: Double) -> Double in return y * x })
            case "÷": self.performMathCalculation({ (x, y) in y / x })
            case "+": self.performMathCalculation({ $1 + $0 })
            case "−": self.performMathCalculation({ $1 - $0 })
            case "√": self.performMathCalculation({ sqrt($0) })
            default: break
        }
    }
    
    // MARK: - Custom Methods
    
    func performMathCalculation(operation: (x: Double, y: Double) -> Double) {
        guard self.operandStack.count >= 2 else { return }
        self.displayValue = operation(x: self.operandStack.removeLast(), y: self.operandStack.removeLast())
        self.enterButtonPressed()
    }

    @nonobjc // obj-c doesn't allow method overloading & this class inherits from UIViewController, which is an obj-c file despite writing it in swift.
    func performMathCalculation(operation: Double -> Double) {
        guard self.operandStack.count >= 1 else { return }
        self.displayValue = operation(self.operandStack.removeLast())
        self.enterButtonPressed()
    }
}

