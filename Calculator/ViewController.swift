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
    @IBAction func enterButtonPressed() {
        self.DigitZeroButton.enabled = false
        self.userIsInTheMiddleOfTypingNumber = false
        
        self.operandStack.append(self.displayValue)
        print("self.operandStack: \(operandStack)")
    }
    
    @IBAction func calculateButtonPressed(sender: UIButton) {
        let calculationSymbol = sender.currentTitle
        
        if self.userIsInTheMiddleOfTypingNumber { self.enterButtonPressed() }
         
        switch calculationSymbol! {
            case "×": self.performMathCalculation(multiply)
            case "÷": self.performMathCalculation(divide)
            case "+": self.performMathCalculation(add)
            case "−": self.performMathCalculation(substract)
            default: break
        }
    }
    
    // MARK: - Custom Methods
    
    func performMathCalculation(operation: (Double, Double) -> Double) {
        guard self.operandStack.count >= 2 else { return }
        self.displayValue = operation(self.operandStack.removeLast(), self.operandStack.removeLast())
        self.enterButtonPressed()
    }
    
    func multiply(operand1: Double, with operand2: Double) -> Double {
        return operand1 * operand2
    }

    func divide(operand1: Double, by operand2: Double) -> Double {
        return operand1 / operand2
    }
    
    func add(operand1: Double, with operand2: Double) -> Double {
        return operand1 + operand2
    }

    func substract(operand1: Double, from operand2: Double) -> Double {
        return operand1 - operand2
    }
}

