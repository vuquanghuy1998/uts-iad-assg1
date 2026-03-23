//
//  calcError.swift
//  calc
//
//  Created by Quang Huy Vu on 21/3/2026.
//  Copyright © 2026 UTS. All rights reserved.
//

// Create an enum list of errors that may be thrown during execution

enum CalcError: Error {
    case invalidNumber(String)
    case invalidOperator(String)
    case divisionByZero
    case overflow
    case invalidExpression
}

// Customise a user-friendly message for each error

extension CalcError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidNumber(let s):   return "Error: '\(s)' is not a valid integer. Please enter a valid integer and try again."
        case .invalidOperator(let s): return "Error: '\(s)' is not a valid operator. Please enter a valid operator and try again."
        case .divisionByZero:         return "Error: Division by zero. Please check your input and try again."
        case .overflow:               return "Error: Integer overflow. Please check your input and try again."
        case .invalidExpression:      return "Error: Invalid expression. Please check your syntax and try again."
        }
    }
}
