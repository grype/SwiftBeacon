//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 4/27/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

// emit(aValue, userInfo: anInfo? = nil, on: aSubject)
public struct EmitMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let argumentList = node.argumentList
        
        var signal: ExprSyntax = "ContextSignal()"
        if let valueExpression = argumentList.first(where: { $0.label == "_" }) {
            signal = "(\(valueExpression.expression) as? Signaling)?.signal ?? WrapperSignal(\(valueExpression.expression))"
        }
        
        var userInfo: ExprSyntax = "nil"
        if let userInfoExpression = argumentList.first(where: { $0.label == "userInfo" }) {
            userInfo = "\(userInfoExpression.expression)"
        }
        
        var subject: ExprSyntax = "Bundle.sharedBeacon"
        if let subjectExpression = argumentList.first(where: { $0.label == "on" }) {
            subject = "\(subjectExpression.expression)"
        }
        
        return """
        { let source = Source()
        let signal = \(signal)
        signal.userInfo = \(userInfo)
        signal.source = source
        \(subject).send(signal) }()
        """
    }
}

// emit(error: Error, userInfo: anInfo? = nil, on: aSubject)
public struct EmitErrorMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let argumentList = node.argumentList
        
        guard let error = argumentList.first else {
            throw EmitError.missingValue
        }
        
        var userInfo: ExprSyntax = "nil"
        if let userInfoExpression = argumentList.first(where: { $0.label == "userInfo" }) {
            userInfo = "\(userInfoExpression.expression)"
        }
        
        var subject: ExprSyntax = "Bundle.sharedBeacon"
        if let subjectExpression = argumentList.first(where: { $0.label == "on" }) {
            subject = "\(subjectExpression.expression)"
        }
        
        return """
        { let source = Source()
        let signal = ErrorSignal(error: \(error.expression))
        signal.userInfo = \(userInfo)
        signal.source = source
        \(subject).send(signal) }()
        """
    }
}

public enum EmitError: Error {
    case missingValue
    case missingSubject
}
