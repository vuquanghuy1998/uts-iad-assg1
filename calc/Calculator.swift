//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {

    // MARK: Performing arithmetic calculation while also reporting overflow errors
    // Here we use specialised methods provided by Swift for both doing the arithmetic calculation & report overflow errors if found
    // see: https://developer.apple.com/documentation/swift/int/addingreportingoverflow(_:)

    func add(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.addingReportingOverflow(b)
        if overflow { throw CalcError.overflow }
        return result
    }

    func subtract(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.subtractingReportingOverflow(b)
        if overflow { throw CalcError.overflow }
        return result
    }

    func multiply(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.multipliedReportingOverflow(by: b)
        if overflow { throw CalcError.overflow }
        return result
    }
    
    func divide(_ a: Int, _ b: Int) throws -> Int {
        guard b != 0 else { throw CalcError.divisionByZero }
        let (result, overflow) = a.dividedReportingOverflow(by: b)
        return result
    }
    
    func remainder(_ a: Int, _ b: Int) throws -> Int {
        guard b != 0 else { throw CalcError.divisionByZero }
        let (result, overflow) = a.remainderReportingOverflow(dividingBy: b)
        return result
    }


    // MARK: - Main calculate function

    func calculate(args: [String]) throws -> String {
        let parser = Parser()
        let tokens = try parser.parse(args: args)
        let result = try evaluate(tokens: tokens)
        return String(result)
    }

    // MARK: - Evaluation

    private func evaluate(tokens: [Token]) throws -> Int {
        var values: [Int] = []
        var ops: [String] = []

        // Separate tokens into values and operators arrays
        for token in tokens {
            switch token {
            case .number(let n): values.append(n)
            case .op(let o):     ops.append(o)
            }
        }

        // Pass 1 — evaluate x, /, % left to right
        var i = 0
        while i < ops.count {
            let op = ops[i]
            if op == "x" || op == "/" || op == "%" {
                let a = values[i]
                let b = values[i + 1]
                let result: Int
                switch op {
                case "x": result = try safeMultiply(a, b)
                case "/":
                    if b == 0 { throw CalcError.divisionByZero }
                    result = a / b
                case "%":
                    if b == 0 { throw CalcError.divisionByZero }
                    result = a % b
                default: fatalError()
                }
                values[i] = result
                values.remove(at: i + 1)
                ops.remove(at: i)
            } else {
                i += 1
            }
        }

        // Pass 2 — evaluate +, - left to right
        var acc = values[0]
        for j in 0..<ops.count {
            let b = values[j + 1]
            switch ops[j] {
            case "+": acc = try safeAdd(acc, b)
            case "-": acc = try safeSubtract(acc, b)
            default: fatalError()
            }
        }

        return acc
    }
}
