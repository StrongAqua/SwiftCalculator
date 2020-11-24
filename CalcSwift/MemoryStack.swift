//
//  MemoryStack.swift
//  CalcSwift
//
//  Created by aprirez on 11/13/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class Example {
    
    var firstNum: Double
    var secondNum: Double?
    var operation: String
    var result: Double

    init(firstNum: Double, secondNum: Double? = nil, operation: String, result: Double) {
        self.firstNum = firstNum
        self.secondNum = secondNum
        self.operation = operation
        self.result = result
    }
}

