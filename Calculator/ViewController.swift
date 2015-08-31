//
//  ViewController.swift
//  Calculator
//
//  Created by Yohannes Wijaya on 8/29/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var userIsInTheMiddleOfTypingNumber = false
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var displayLabel: UILabel!
    
    // MARK: - IBAction Properties
    @IBAction func appendDigitButtonPressed(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            self.displayLabel.text! += sender.currentTitle!
        }
        else {
            self.displayLabel.text = sender.currentTitle!
            self.userIsInTheMiddleOfTypingNumber = true
        }
    }
}

