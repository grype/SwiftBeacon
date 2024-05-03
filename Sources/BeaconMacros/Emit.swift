//
//  File.swift
//
//
//  Created by Pavel Skaldin on 4/27/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

// emit([Any|error:Error], userInfo: Any? = nil, on: Subject = Bundle.sharedBeacon)
public struct EmitMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let argumentList = node.argumentList
        
        var userInfo: ExprSyntax = "nil"
        if let userInfoExpression = argumentList.first(where: { $0.label?.text == "userInfo" }) {
            userInfo = "\(userInfoExpression.expression)"
        }
        
        var signal: ExprSyntax!
        if let value = argumentList.first(where: { $0.label == nil }) {
            signal = "Signal.representing(\(value.expression), userInfo: \(userInfo), source: Source())"
        }
        else if let error = argumentList.first(where: { $0.label?.text == "error" }) {
            signal = "Signal.representing(error: \(error.expression), userInfo: \(userInfo), source: Source())"
        }
        else {
            signal = "Signal.representing(userInfo: \(userInfo), source: Source())"
        }
        
        var subject: ExprSyntax = "Bundle.sharedBeacon"
        if let subjectExpression = argumentList.first(where: { $0.label?.text == "on" }) {
            subject = "\(subjectExpression.expression)"
        }
        
        return "\(subject).send(\(signal))"
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
