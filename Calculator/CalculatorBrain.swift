//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Johnson Zhou on 14/08/2016.
//  Copyright © 2016 Johnson Zhou. All rights reserved.
//

import Foundation

func cot(_ angle: Double) -> Double {
    return 1/tan(angle)
}

func acot(_ ratio: Double) -> Double {
    return 1/atan(ratio)
}

class CalculatorBrain {
    
    var isDeg = false
    var isPartialResult: Bool {
        return pendingBinary != nil
    }
    var description = ""
    var typingExpression = false     // started not typing an expression (unchangable)
    var startOfCalculation = false   // only used in setOperand to clear history
    
    fileprivate var constantValues: [String: Double] = [
        "π": M_PI,
        "e": M_E
    ]
    
    fileprivate var operations = [
        "π": Operation.constant(M_PI),
        "e": Operation.constant(M_E),
        
        "+": Operation.binaryOperation() { $0 + $1 } ,
        "−": Operation.binaryOperation() { $0 - $1 } ,
        "×": Operation.binaryOperation() { $0 * $1 } ,
        "÷": Operation.binaryOperation() { $0 / $1 } ,
        "^": Operation.binaryOperation() { pow($0, $1) } ,
        "log": Operation.unaryOperation(log10),
        "lg": Operation.unaryOperation(log2),
        "ln": Operation.unaryOperation(log),
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "cot": Operation.unaryOperation(cot),
        "asin": Operation.unaryOperation(asin),
        "acos": Operation.unaryOperation(acos),
        "atan": Operation.unaryOperation(atan),
        "acot": Operation.unaryOperation(acot),
        "√": Operation.unaryOperation(sqrt),
        "∛": Operation.unaryOperation() { pow($0, 1/3) },
        "^2": Operation.unaryOperation() { pow($0, 2) },
        "^3": Operation.unaryOperation() { pow($0, 3) },
        "10^": Operation.unaryOperation() { pow(10, $0) },
        "e^": Operation.unaryOperation() { pow(M_E, $0) },
        "±": Operation.unaryOperation() { -$0 },
        "1/x": Operation.unaryOperation() { 1/$0 },
        "Rand": Operation.unaryOperation()  { _ in return (Double(arc4random()) / Double(UINT32_MAX))   },
        "=": Operation.equal,
        //"M": Operation.Constant(0),
        "h": Operation.constant(Double(6.62607004E-34)),
        "c": Operation.constant(299792458),
        "→M": Operation.setConstantValue
        
    ]
    
    fileprivate var trigOperations = [
        "sin", "cos", "tan", "cot", "asin", "acos", "atan", "acot"
    ]
    
    fileprivate var rightUnaryOperations = [
        "^2", "^3"
    ]
    
    
    enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equal
        case constant(Double)
        case setConstantValue
    }
    
    fileprivate var accumulator = 0.0
    
    func setOperand(_ operand: Double) {
        internalProgram.append(operand as AnyObject)
        accumulator = operand
        print(accumulator)
        if startOfCalculation {
            print("description reset")
            description = ""
            typingExpression = false    // set to default (to make sure the first operand is shown
        }
    }
    
    func setVariableOperand(_ operand: Double) {
        accumulator = operand
        print(accumulator)
        if startOfCalculation {
            typingExpression = false    // set to default (to make sure the first operand is shown
        }
    }
    
    var pendingBinary: (firstOperand: Double, function: (Double, Double) -> Double)?
    
    fileprivate var numberFormatter = NumberFormatter()
    
    fileprivate func getAccumulatorString() -> String {
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumFractionDigits = 6
        return numberFormatter.string(from: NSNumber(value: accumulator))!
    }
    
    fileprivate func checkUnarySide(_ symbol: String, description: String) -> String{
        if rightUnaryOperations.contains(symbol) {
            return description + symbol
        } else {
            return symbol + description
        }
    }
    
    fileprivate func unaryExpression(_ symbol: String) {
        if typingExpression {
            description = checkUnarySide(symbol, description: "(" + description + ")")
        } else {
            description = description + checkUnarySide(symbol, description: getAccumulatorString())
        }
        
    }
    
    fileprivate var lastOperationPriority = 10, thisOperationPriority = 10
    
    fileprivate func binaryExpression(_ symbol: String) {
        
        switch symbol {
        case "+", "−":
            thisOperationPriority = 1
        case "×", "÷":
            thisOperationPriority = 2
        case "^":
            thisOperationPriority = 3
        default:
            break
        }
        if !typingExpression {
            description += getAccumulatorString()
        }   // use conditional statement to make sure typed operand is appended
        if lastOperationPriority < thisOperationPriority {
            description = "(" + description + ")" + symbol
        } else {
            description = description + symbol
        }
        lastOperationPriority = thisOperationPriority
    }
    
    func performOperation(_ mathematicalSymbol: String) {

        internalProgram.append(mathematicalSymbol as AnyObject)
        print(program)
        
        if trigOperations.contains(mathematicalSymbol) && isDeg {
            accumulator = accumulator / 180 * M_PI
        }
        
        if let operation = operations[mathematicalSymbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                description += mathematicalSymbol
                typingExpression = true
                startOfCalculation = false
            case .unaryOperation(let function):
                unaryExpression(mathematicalSymbol)
                accumulator = function(accumulator)
                typingExpression = true
                //startOfCalculation = false
            case .binaryOperation(let function):                binaryExpression(mathematicalSymbol)
                equal()
                pendingBinary = (accumulator, function)
                startOfCalculation = false
            case .equal:
                if !typingExpression {
                    description += getAccumulatorString()
                }
                equal()
                typingExpression = true     // unchangable! set to true because description need to be built on that without a first operand (the original expression is the first operand) If not set to true, brain would append another accumulator value to description
                startOfCalculation = true
                
            
            case .setConstantValue:
                var symbol = mathematicalSymbol
                symbol.remove(at: symbol.startIndex)
                operations[symbol] = Operation.constant(accumulator)
                internalProgram.remove(at: (internalProgram.endIndex - 1))
            }
        } else {
            operations[mathematicalSymbol] = Operation.constant(0)
            accumulator = 0
            description += mathematicalSymbol
            typingExpression = true
            startOfCalculation = false
        }
    }
    
    func equal() {
        if pendingBinary != nil {
            accumulator = pendingBinary!.function(pendingBinary!.firstOperand, accumulator)
            pendingBinary = nil
        }
        typingExpression = false    // The current expression is finished
    }
    
    
    func clear() {
        accumulator = 0
        description = ""
        pendingBinary = nil
        typingExpression = false    // set to default
        internalProgram.removeAll()
    }
    
    var result: Double {
        return accumulator
    }
    
    fileprivate var internalProgram = [AnyObject]()
    
    func deleteProgram() {
        internalProgram.removeAll()
    }
    
    func removeLastProgramObject() {
        internalProgram.removeLast()
    }
    
    var program: [AnyObject] {
        get {
            return internalProgram
        }
        set {
            startOfCalculation = false
            typingExpression = false
            for object in newValue {
                if let number = object as? Double {
                    setOperand(number)
                } else  if let operation = object as? String {
                    performOperation(operation)
                }
            }
        }
    }
    
    func calculateProgram() {
        program = internalProgram
    }
    /*
    func appendVariableValue(variableName name: String, value: Double?) {
        if let variableValue = value {
            
        }
    } */
}
