//
//  ViewController.swift
//  Calculator
//
//  Created by Yohannes Wijaya on 8/29/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//
//

/*
todo: 
1. tweak the significant digit treshold including inversion

bug: after entering a number, pressing floating point will append instead of overwrite
*/

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatingPointButton.enabled = false
        
        self.tapGestureToShowAllClearTipOnce = UITapGestureRecognizer(target: self, action: "alertAboutAllClearFunctionOnce:")
        self.clearButton.addGestureRecognizer(tapGestureToShowAllClearTipOnce)
        
        self.longPressGestureToEmptyOperandStack = UILongPressGestureRecognizer(target: self, action: "emptyOperandStack:")
        self.longPressGestureToEmptyOperandStack.minimumPressDuration = 1.0
        self.clearButton.addGestureRecognizer(longPressGestureToEmptyOperandStack)
    }
    
    // MARK: - Stored Properties
    
    var isUserInTheMiddleOfTyping = false
    var tapGestureToShowAllClearTipOnce: UIGestureRecognizer!
    var longPressGestureToEmptyOperandStack: UILongPressGestureRecognizer!
    
    // var operandStack: [Double] = []
    var operandStack = Array<Double>()
    
    // MARK: - Computed Properties
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(self.displayLabel.text!)!.doubleValue
        }
        set {
//            print("newValue: \(newValue)")
//            print("floorValue: \(floor(newValue))")
            self.displayLabel.text = newValue - floor(newValue) < 0.01 ? "\(Int(newValue))" : String(format: "%.3f", newValue)
            self.isUserInTheMiddleOfTyping = false
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var historyDisplayLabel: UILabel!
    @IBOutlet weak var floatingPointButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
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
            self.floatingPointButton.enabled = true
        }
    }
    
    @IBAction func appendFloatingPointButton(sender: UIButton) {
        self.displayLabel.text!.append("." as Character)
        self.floatingPointButton.enabled = false
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
        self.clearDisplay()
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        guard self.displayLabel.text!.characters.count > 1 else {
            self.displayLabel.text = "0"
            return
        }
        self.displayLabel.text = String(dropLast(self.displayLabel.text!.characters))
    }
    
    @IBAction func enterButton() {
        self.isUserInTheMiddleOfTyping = false
        self.floatingPointButton.enabled = false
        self.operandStack.append(self.displayValue)
        self.historyDisplayLabel.text! += "\(self.displayValue) "
        print("self.operandStack: \(self.operandStack)")
    }
    
    @IBAction func performMathOperationButton(sender: UIButton) {
        let calculationSymbol = sender.currentTitle!
        self.historyDisplayLabel.text! +=  "\(calculationSymbol)"
        
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
    
    @IBAction func invertDigitButton(sender: UIButton) {
        var numberFromString = NSNumberFormatter().numberFromString(self.displayLabel.text!)!.doubleValue
        if numberFromString > 0 { numberFromString -= (numberFromString * 2) }
        else if numberFromString < 0 { numberFromString += (-numberFromString * 2) }
        self.displayLabel.text = "\(numberFromString)"
    }
    
    
    // MARK: - Custom Methods
    
    func alertAboutAllClearFunctionOnce(gestureRecognizer: UIGestureRecognizer) {
            let alertController = UIAlertController(title: "Tip: ", message: "If you tap & hold C, you can erase all memories.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "I got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                self.clearButton.removeGestureRecognizer(self.tapGestureToShowAllClearTipOnce)
            })
    }
    
    func clearDisplay() {
        self.floatingPointButton.enabled = false
        self.displayLabel.text = "0"
        self.historyDisplayLabel.text = ""
        self.isUserInTheMiddleOfTyping = false
    }
    
    func emptyOperandStack(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let alertController = UIAlertController(title: "Erase All Memories?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Erase", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.operandStack = []
                self.clearDisplay()
                print("self.operandStack: \(self.operandStack)")
            }))
            alertController.addAction(UIAlertAction(title: "Don't erase", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func performMathCalculation(operation: (x: Double, y: Double) -> Double) {
        guard self.operandStack.count >= 2 else { return }
        self.displayValue = operation(x: self.operandStack.removeLast(), y: self.operandStack.removeLast())
        self.historyDisplayLabel.text! += " = "
        self.enterButton()
    }

    @nonobjc // obj-c doesn't allow method overloading & this class inherits from UIViewController, which is an obj-c file despite writing it in swift.
    func performMathCalculation(operation: Double -> Double) {
        guard self.operandStack.count >= 1 else { return }
        self.displayValue = operation(self.operandStack.removeLast())
        self.enterButton()
    }
}

