//
//  Parser.swift
//  calc
//
//  Created by Quang Huy Vu on 21/3/2026.
//  Copyright © 2026 UTS. All rights reserved.
//

// This file retrieves user input from main.swift and validates if there is any elements
// that may potentially causes errors during the main calculation stage in the Calculator.swift file.

class Parser {
    
    let validOperators = ["+", "-", "x", "/", "%"] // Define allowed operators
    
    // Validate the user input string to see if it's in the right format (with numbers and operators alternating)
    func parse(args: [String]) throws -> [Token] {
        guard !args.isEmpty else { throw CalcError.invalidExpression } // Throws an error if user enters nothing
        
        // Requires that the string must have an odd number of arguments
        // This is because the input string should always follow this for at: number operator number operator number...
        guard args.count % 2 != 0 else { throw CalcError.invalidExpression }
        
        // Create an empty array to store the validated/converted arguments, so that later we will pass it to calculator.swift for processing
        var tokens: [Token] = []
        
        // Now we validate that the even positions must be numbers and the odd positions must be operators
        // following the format: number operator number operator number...
        for (i, arg) in args.enumerated() {
            if i % 2 == 0 {
                // Even positions (0, 2, 4...) must be numbers. Before appending the number to the final tokens array, try to clean up and validate it using the parseNumber helper function below.
                tokens.append(Token.number(try validateNumber(arg)))
            } else {
                // Odd positions (1, 3, 5...) must be operators. Before appending the operator to the final tokens array, try tovalidate it using the parseOperator helper function below.
                tokens.append(Token.op(try validateOperator(arg)))
            }
        }
        
        return tokens // This class must return the tokens value so that we can pass it to the calculator.swift file
    }
    
    // A helper function (private to this class only) to clean up/validate the numbers
    private func validateNumber(_ s: String) throws -> Int {
        var token = s
        
        // Stripping the '+' sign before a number, this may cause an error when we wrap the number in the Int() command
        if token.hasPrefix("+") {
            token = String(token.dropFirst())
        }
        
        // Reject decimal numbers (by checking if it contains the '.')
        guard let value = Int(token), !s.contains(".") else {
            throw CalcError.invalidNumber(s)
        }
        
        return value
    }
    
    // A helper function (private to this class only) to validate the operators (against the list of allowed operators)
    private func validateOperator(_ s: String) throws -> String {
        guard validOperators.contains(s) else {
            throw CalcError.invalidOperator(s)
        }
        return s
    }
}
