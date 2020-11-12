//
//  ViewController.swift
//  CalcSwift
//
//  Created by aprirez on 11/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    var firstNum: Double = 0
    var secondNum: Double = 0
    var operation: Int = 0
    var startTyping: Bool = true
    var dotIsPressed: Bool = false
    
    var currentInput: Double {
        get {
            return Double(result.text!)!
        }
        
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                result.text = "\(valueArray[0])"
            } else {
                let text = String(format: "%.7g", newValue)
                result.text = text
            }
        }
    }
    
    
    @IBAction func digits(_ sender: UIButton) {
        
        let textCount = result.text!.count
        
        if startTyping == true {
            result.text = String(sender.tag)
            startTyping = false
            
        } else {
            if textCount < 15 {
                result.text = result.text! + String(sender.tag)
            }
        }
        
    }
    
    @IBAction func buttons(_ sender: UIButton) {
        if result.text != "" && sender.tag != 10 && sender.tag != 15 {
            firstNum = currentInput
            
            if sender.tag == 11 {
                result.text = "/"
            }
            else if sender.tag == 12 {
                result.text = "x"
            }
            else if sender.tag == 13 {
                result.text = "-"
            }
            else if sender.tag == 14 {
                result.text = "+"
            }
            
            operation = sender.tag
            startTyping = true
            dotIsPressed = false
        }
        else if sender.tag == 15 {
            secondNum = currentInput
            if operation == 11 {
                currentInput =  firstNum / secondNum
            }
            else if operation == 12 {
                currentInput =  firstNum * secondNum
            }
            else if operation == 13 {
                currentInput = firstNum - secondNum
            }
            else if operation == 14 {
                currentInput = firstNum + secondNum
            }
            startTyping = true
        }
        else if sender.tag == 10 {
            startTyping = true
            result.text = "0"
            firstNum = 0
            secondNum = 0
            operation = 0
            dotIsPressed = false
            
        }
    }
    
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
        
    }
    
    @IBAction func squareButtonPressed(_ sender: UIButton) {
        currentInput = sqrt(currentInput)
        
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if startTyping == false && !dotIsPressed {
            result.text = result.text! + "."
            dotIsPressed = true
        } else if  startTyping == true && !dotIsPressed {
            result.text = "0."
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

