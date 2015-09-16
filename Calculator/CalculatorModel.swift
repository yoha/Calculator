//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Yohannes Wijaya on 9/16/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import Foundation

class CalculatorModel {

    // MARK: - Enumeration Declaration
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operandValue): return "\(operandValue)"
                    case .UnaryOperation(let operatorSymbol, _): return operatorSymbol
                    case .BinaryOperation(let operatorSymbol, _): return operatorSymbol
                }
            }
        }
    }
    
    // MARK: - Primary Initializer
    
    init() {
        func mathOperation(op: Op) {
            self.availableMathOperators[op.description] = op
        }
        mathOperation(Op.BinaryOperation("+", { (x: Double, y: Double) -> Double in return y + x }))
        mathOperation(Op.BinaryOperation("−", { (x, y) -> Double in y - x}))
        mathOperation(Op.BinaryOperation("÷") { $1 / $0 })
        mathOperation(Op.BinaryOperation("×", * ))
        mathOperation(Op.UnaryOperation("√", sqrt))
    }

    // MARK: - Private Stored Properties
    
    private var operandOrOperatorStack = [Op]()
    private var availableMathOperators = [String: Op]()
    
    // MARK: - Private Methods
    
    private func evaluateOpsRecursively(var opsStack: [Op]) -> (evaluationResult: Double?, remainingOpsInStack: [Op]) {
        if opsStack.count >= 1 {
            let lastOpInTheStack = opsStack.removeLast()
            
            switch lastOpInTheStack {
                case .Operand(let anOperand):
                    return (anOperand, opsStack)
                case .UnaryOperation(_, let mathOperator):
                    let opToBeEvaluated = self.evaluateOpsRecursively(opsStack)
                    if let operandToBeEvaluated = opToBeEvaluated.evaluationResult {
                        return (mathOperator(operandToBeEvaluated), opToBeEvaluated.remainingOpsInStack)
                    }
                case .BinaryOperation(_, let mathOperator):
                    let op1TobeEvaluated = self.evaluateOpsRecursively(opsStack)
                    if let operand1ToBeEvaluated = op1TobeEvaluated.evaluationResult {
                        let op2ToBeEvaluated = self.evaluateOpsRecursively(op1TobeEvaluated.remainingOpsInStack)
                        if let operand2ToBeEvaluated = op2ToBeEvaluated.evaluationResult {
                            return (mathOperator(operand1ToBeEvaluated, operand2ToBeEvaluated), op2ToBeEvaluated.remainingOpsInStack)
                        }
                    }
            }
        }
        return (nil, opsStack)
    }
    
    // MARK: - Public Methods
    
    func emptyoperandOrOperatorStack() {
        self.operandOrOperatorStack = []
        print(self.operandOrOperatorStack)
    }
    
    func performCalculation() -> Double? {
        let (computedResult, leftoverOpsInStack) = self.evaluateOpsRecursively(self.operandOrOperatorStack)
        print("\(self.operandOrOperatorStack) = \(computedResult) with \(leftoverOpsInStack) remaining.")
        return computedResult
    }
    
    func pushOperand(operand: Double) -> Double? {
        self.operandOrOperatorStack.append(Op.Operand(operand))
        return self.performCalculation()
    }
    
    func pushMathOperator(mathOperatorSymbol: String) -> Double? {
        if let mathOperation = self.availableMathOperators[mathOperatorSymbol] {
            self.operandOrOperatorStack.append(mathOperation)
        }
        return self.performCalculation()
    }
}