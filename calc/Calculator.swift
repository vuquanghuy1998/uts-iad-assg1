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
        let (result, overflow) = a.addingReportingOverflow(b) // Create a tuple that returns both the result of the arithmetic calculation and overflow error.
        if overflow { throw CalcError.overflow } // Report overflow error if found.
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
        guard b != 0 else { throw CalcError.divisionByZero } // Prevent the divide-by-zero problem
        let (result, overflow) = a.dividedReportingOverflow(by: b)
        if overflow { throw CalcError.overflow }
        return result
    }
    
    func remainder(_ a: Int, _ b: Int) throws -> Int {
        guard b != 0 else { throw CalcError.divisionByZero }
        let (result, overflow) = a.remainderReportingOverflow(dividingBy: b)
        if overflow { throw CalcError.overflow }
        return result
    }


    // MARK: The main "calculate" function that calls the parser and computeExpressionOrder helper to parse the input and evaluate the order of mathemetical computations

    func calculate(args: [String]) throws -> String {
        let parser = Parser()
        let tokens = try parser.parse(args: args)
        let result = try computeExpressionOrder(tokens: tokens)
        return String(result)
    }

    // MARK: The private helper function that decides the computation order and perform calculation by that order

    private func computeExpressionOrder(tokens: [Token]) throws -> Int {
        var values: [Int] = []
        var ops: [String] = []

        // Separate tokens into values and operators arrays
        for token in tokens {
            switch token {
            case .number(let n): values.append(n)
            case .op(let o):     ops.append(o)
            }
        }

        // Pass 1: find x, / and % and perform these calculations first
        var i = 0
        
        // Create a while loop that finds and works with x, / and %
        while i < ops.count {
            let op = ops[i]
            if op == "x" || op == "/" || op == "%" {
                // Create temporary constants a, b to store the number at i and i+1 positions and then perform calculations with it
                let a = values[i]
                let b = values[i + 1]
                let result: Int
                // Use appropriate functions accordingly to the operators found at i position
                switch op {
                case "x": result = try multiply(a, b)
                case "/": result = try divide(a, b)
                case "%": result = try remainder(a, b)
                default: throw CalcError.invalidOperator(op)
                }
                values[i] = result // Assign the computed result to the number at i position
                values.remove(at: i + 1) // Delete the number at i+1 position because the calculated result has already been replaced the original number at i position
                ops.remove(at: i) // Also remove the operator at i position as we have finished handling it
            } else {
                i += 1
            }
        }

        // Pass 2: work with +, - from left to right
        var result = values[0] // Set the initial value of the 'result' variable - used to store the final result of the calculation
        
        // Create a loop to handle the +, - calculation
        for j in 0..<ops.count {
            let b = values[j + 1] // Set b to the number at the position after the current number (i+1)
            switch ops[j] {
            case "+": result = try add(result, b)
            case "-": result = try subtract(result, b)
            default: throw CalcError.invalidOperator(ops[j])
            }
        }

        return result
    }
}
