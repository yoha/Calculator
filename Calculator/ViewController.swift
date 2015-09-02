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
        self.DigitZeroButton.enabled = false
        self.userIsInTheMiddleOfTypingNumber = false
        self.floatingPointButton.enabled = true
        
        self.operandStack.append(self.displayValue)
        print("self.operandStack: \(operandStack)")
        if self.displayLabel.text!.characters.contains(".") { print("y") }
    }
    
    @IBAction func calculateButtonPressed(sender: UIButton) {
        let calculationSymbol = sender.currentTitle
        
        if self.userIsInTheMiddleOfTypingNumber { self.enterButtonPressed() }
         
        switch calculationSymbol! {
            // if there's only 1 argument or if the argument is the last in line, we can move it to the body and take out the parentheses.
            case "×": self.performMathCalculation{$1 * $0}
            case "÷": self.performMathCalculation{$1 / $0}
            case "+": self.performMathCalculation{$1 + $0}
            case "−": self.performMathCalculation{$1 - $0}
            case "√": self.performMathCalculation{sqrt($0)}
            default: break
        }
    }
    
    // MARK: - Custom Methods
    
    func performMathCalculation(operation: (Double, Double) -> Double) {
        guard self.operandStack.count >= 2 else { return }
        self.displayValue = operation(self.operandStack.removeLast(), self.operandStack.removeLast())
        self.enterButtonPressed()
    }

    @nonobjc // obj-c doesn't allow method overloading & this class inherits from UIViewController, which is an obj-c file despite writing it in swift.
    func performMathCalculation(operation: Double -> Double) {
        guard self.operandStack.count >= 1 else { return }
        self.displayValue = operation(self.operandStack.removeLast())
        self.enterButtonPressed()
    }
}

