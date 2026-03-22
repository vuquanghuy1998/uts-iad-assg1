//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {

    // MARK: - Safe arithmetic

    func safeAdd(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.addingReportingOverflow(b)
        if overflow { throw CalcError.overflow }
        return result
    }

    func safeSubtract(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.subtractingReportingOverflow(b)
        if overflow { throw CalcError.overflow }
        return result
    }

    func safeMultiply(_ a: Int, _ b: Int) throws -> Int {
        let (result, overflow) = a.multipliedReportingOverflow(by: b)
        if overflow { throw CalcError.overflow }
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
