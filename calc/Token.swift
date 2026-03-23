//
//  Token.swift
//  calc
//
//  Created by Quang Huy Vu on 21/3/2026.
//  Copyright © 2026 UTS. All rights reserved.
//

// Defines the Token type used to represent parsed inputs (numbers and operators) before evaluation.

enum Token {
    case number(Int)
    case op(String)
}
