//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hannah Zhang on 2017/6/23.
//  Copyright © 2017年 com.hz.stanford. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var descAccmulator: String?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
   
   
    private var operations: Dictionary<String, Operation> =
    [
    "π"   : Operation.constant(Double.pi), //Double.pi
    "e"   : Operation.constant(M_E), // M_E
    "√"   : Operation.unaryOperation(sqrt), // sqrt,
    "cos" : Operation.unaryOperation(cos), // cos
    "sin" : Operation.unaryOperation(sin),
    "tan" : Operation.unaryOperation(tan),
    "%"   : Operation.unaryOperation({$0 / 100}),
    "±"   : Operation.unaryOperation({ -$0 }),
    "×"   : Operation.binaryOperation({ $0 * $1}),
    "÷"   : Operation.binaryOperation({ $0 / $1}),
    "+"   : Operation.binaryOperation({ $0 + $1}),
    "-"   : Operation.binaryOperation({ $0 - $1}),
    "="   : Operation.equals
        
    ]
    
    mutating func performOperation(_ symbol: String) {
       
        if let operatoin = operations[symbol] {
            switch operatoin {
            case .constant(let value):
                accumulator = value
                if descAccmulator != nil {
                    descAccmulator = descAccmulator! + symbol
                }else {
                    descAccmulator = symbol
                }
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    if descAccmulator != nil {
                        descAccmulator = symbol + descAccmulator!
                    } else {
                        descAccmulator = symbol
                    }
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function,firstOperand: accumulator!)
                    accumulator = nil
                    resultIsPending = true
                    if descAccmulator != nil {
                        descAccmulator = descAccmulator! + symbol
                    }else {
                        descAccmulator = symbol
                    }
                }
                
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
                descAccmulator = ""
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var resultIsPending = false
   
   
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var description: String? {
        get {
            return descAccmulator
        }
    }
}
