//
//  FeaturePromise.swift
//  CalcSwift
//
//  Created by aprirez on 11/11/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class Future<T> {
    fileprivate var result: Result<T, Error>? {
        didSet {
            guard let result = result else { return }
            callbacks.forEach { $0(result) }
        }
    }
    private var callbacks = [(Result<T, Error>) -> Void]()
    
    func add(callback: @escaping (Result<T, Error>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
}

class Promise<T>: Future<T> {
    init(value: T? = nil) {
        super.init()
        result = value.map(Result.success)
    }
    
    func fulfill(with value: T) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
}

enum BossError: Error {
    case noMoney
}

class Employee {
    
    var salary: Future<Int>
    
    init(_ salary: Future<Int>) {
        self.salary = salary
        self.salary.add(callback: goShopping)
    }
    
    func goShopping(_ salary: Result<Int, Error>) {
        switch salary {
            case .success(let money):
                print("I've got a salary $\(money), I'm go shopping!!!")
            case .failure(let error):
                print("No money this month :(, boss said - \(error.localizedDescription)")
        }
    }
    
}

class Boss {
    
    var payMoney = Promise<Int>()
    
    func doPayMoney(_ amount: Int) {
        payMoney.fulfill(with: amount)
    }
    
    func doNotPayMoney() {
        payMoney.reject(with: BossError.noMoney)
    }
    
}

class TaskSelfRunner {
    
    init() {
        debugPrint("Run!!!")
        
        let boss = Boss()
        
        let _ = Employee(boss.payMoney)
        let _ = Employee(boss.payMoney)
        
        boss.doPayMoney(1000)
        //boss.doNotPayMoney()
        
    }
    
}
