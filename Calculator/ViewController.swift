//
//  ViewController.swift
//  Calculator
//
//  Created by Hannah Zhang on 2017/6/21.
//  Copyright © 2017年 com.hz.stanford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var dotAdded = false
  
    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if dotAdded {
                digit = ""
            } else {
                dotAdded = true
            }
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        dotAdded = false
    }
    var displayValue: Double {
        get {
           return Double(display.text!)!
        }
        set {
           display.text = String(newValue)
        }
    }
    
    var descValue: String {
        get {
            return desc.text!
        }
        set {
            desc.text = newValue
        }
    }

    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            dotAdded = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
       
        
        if brain.resultIsPending {
            descValue = brain.description! + "...";
        } else {
            descValue = brain.description! + "="
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
       
    }

}

