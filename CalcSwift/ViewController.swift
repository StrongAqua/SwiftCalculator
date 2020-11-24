//
//  ViewController.swift
//  CalcSwift
//
//  Created by aprirez on 11/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var memoryTable: UITableView!
    
    var firstNum: Double = 0
    var secondNum: Double = 0
    var operation: String?
    var startTyping: Bool = true
    var dotIsPressed: Bool = false
    var memory: [Example] = []
    let maxInputCount = 15
    let cellReuseIdentifier = "cell"
    
    var currentInput: Double {
        get {
            guard let text = result.text else {
                fatalError("ERROR: void input!")
            }
            if isOperation(text) {
                return firstNum
            }
            guard let result = Double(text) else {
                fatalError("ERROR: not a number!")
            }
            return result
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
        
        let text = result.text ?? ""
        let textCount = text.count
        
        if startTyping == true {
            result.text = String(sender.tag)
            startTyping = false
        } else {
            if textCount < maxInputCount {
                result.text = text + String(sender.tag)
            }
        }
        
    }
    
    func isOperation(_ input: String) -> Bool {
        switch input {
            case "/", "x", "-", "+":
                return true
            default: return false
        }
    }
    
    @IBAction func buttons(_ sender: UIButton) {

        guard let title = sender.currentTitle,
                  title.isEmpty == false
        else { return }

        repeat {

            if isOperation(title)
            {
                if operation == nil {
                    firstNum = currentInput
                }
                result.text = title
                operation = title
                startTyping = true
                dotIsPressed = false
                break
            }
            
            if title == "=" {
                guard let operation = self.operation else { return }
                secondNum = currentInput
                if operation == "/" && secondNum.isZero {
                    clearState("E")
                    return
                }
                switch operation {
                    case "/": currentInput = firstNum / secondNum
                    case "x": currentInput = firstNum * secondNum
                    case "-": currentInput = firstNum - secondNum
                    case "+": currentInput = firstNum + secondNum
                    default:
                    fatalError("ERROR: unknown operation!")
                }
                let example = Example(firstNum: firstNum, secondNum: secondNum, operation: operation, result: currentInput)
                memory.append(example)
                memoryTable.reloadData()
                startTyping = true
                self.operation = nil
                break
            }
                
            if title == "C" {
                clearState("0")
                break
            }
            
        } while( false )
    }
    
    func clearState(_ text: String) {
        startTyping = true
        result.text = text
        firstNum = 0
        secondNum = 0
        operation = nil
        dotIsPressed = false
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func squareButtonPressed(_ sender: UIButton) {
        let result = sqrt(currentInput)
        let example = Example(firstNum: currentInput, operation: sender.titleLabel?.text ?? "E", result: result)
        currentInput = result
        memory.append(example)
        memoryTable.reloadData()
        startTyping = true
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if dotIsPressed == true { return }
        
        result.text = startTyping
            ? "0."
            : result.text! + "."
        
        startTyping = false
        dotIsPressed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the table view cell class and its reuse id
        self.memoryTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        // This view controller itself will provide the delegate methods and row data for the table view.
        memoryTable.delegate = self
        memoryTable.dataSource = self
        memoryTable.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memory.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        guard
          let cell = self.memoryTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier),
          let cellLabel = cell.textLabel
        else { return UITableViewCell() }
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.backgroundColor = .black
        
        let element = memory[memory.count - indexPath.row - 1]
        cellLabel.textColor = UIColor.white
        cellLabel.textAlignment = .right
        let secondNum = (element.secondNum == nil) ? "" : String(element.secondNum ?? 0.0)
        cellLabel.text = "\(element.firstNum) \(element.operation) \(secondNum) = \(element.result)"
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let element = memory[memory.count - indexPath.row - 1]
        result.text = String(element.result)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
}


