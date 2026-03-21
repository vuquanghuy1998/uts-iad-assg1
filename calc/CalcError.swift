//
//  calcError.swift
//  calc
//
//  Created by Quang Huy Vu on 21/3/2026.
//  Copyright © 2026 UTS. All rights reserved.
//

enum CalcError: Error {
    case invalidNumber(String)
    case invalidOperator(String)
    case divisionByZero
    case overflow
    case invalidExpression
}

extension CalcError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidNumber(let s):   return "Error: '\(s)' is not a valid integer. Please enter a valid integer and try again."
        case .invalidOperator(let s): return "Error: '\(s)' is not a valid operator. Please enter a valid operator and try again."
        case .divisionByZero:         return "Error: division by zero. Please check your input and try again."
        case .overflow:               return "Error: integer overflow. Please check your input and try again."
        case .invalidExpression:      return "Error: invalid expression. Please check your syntax and try again."
        }
    }
}
