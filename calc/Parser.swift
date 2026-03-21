//
//  Parser.swift
//  calc
//
//  Created by Quang Huy Vu on 21/3/2026.
//  Copyright © 2026 UTS. All rights reserved.
//

class Parser {
    
    let validOperators = ["+", "-", "x", "/", "%"]
    
    func parse(args: [String]) throws -> [Token] {
        guard !args.isEmpty else { throw CalcError.invalidExpression }
        
        // Must have odd number of arguments: num op num op num...
        guard args.count % 2 != 0 else { throw CalcError.invalidExpression }
        
        var tokens: [Token] = []
        
        for (i, arg) in args.enumerated() {
            if i % 2 == 0 {
                // Even positions (0, 2, 4...) must be numbers
                tokens.append(Token.number(try parseNumber(arg)))
            } else {
                // Odd positions (1, 3, 5...) must be operators
                tokens.append(Token.op(try parseOperator(arg)))
            }
        }
        
        return tokens
    }
    
    private func parseNumber(_ s: String) throws -> Int {
        var token = s
        
        // Handle unary + by stripping it
        if token.hasPrefix("+") {
            token = String(token.dropFirst())
        }
        
        // Reject anything that isn't a plain integer
        guard let value = Int(token), !s.contains(".") else {
            throw CalcError.invalidNumber(s)
        }
        
        return value
    }
    
    private func parseOperator(_ s: String) throws -> String {
        guard validOperators.contains(s) else {
            throw CalcError.invalidOperator(s)
        }
        return s
    }
}
