//
//  EmitMacro.swift
//
//
//  Created by Pavel Skaldin on 4/27/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

// emit([Any|error:Error|signal:Signal|publisher:Publisher], userInfo: Any? = nil, on: Subject = Bundle.sharedBeacon)
public struct EmitMacro: ExpressionMacro {
    public static var formatMode: FormatMode {
        return .disabled
    }
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let argumentList = node.argumentList
        
        var userInfo: ExprSyntax = "nil"
        if let userInfoExpression = argumentList.first(where: { $0.label?.text == "userInfo" }) {
            userInfo = "\(userInfoExpression.expression)"
        }
        
        var subject: ExprSyntax = "Beacon"
        if let subjectExpression = argumentList.first(where: { $0.label?.text == "on" }) {
            subject = "\(subjectExpression.expression)"
        }
        
        var signal: ExprSyntax!
        if let value = argumentList.first(where: { $0.label == nil }) {
            signal = "Signal.representing(\(value.expression), userInfo: \(userInfo), source: Source())"
        }
        else if let error = argumentList.first(where: { $0.label?.text == "error" }) {
            signal = "Signal.representing(error: \(error.expression), userInfo: \(userInfo), source: Source())"
        }
        else if let sig = argumentList.first(where: { $0.label?.text == "signal" }) {
            signal = "\(sig.expression)"
        }
        else if let pub = argumentList.first(where: { $0.label?.text == "publisher" }) {
            return "\(pub.expression).map { Signal.representing($0, userInfo: \(userInfo), source: Source()) }.subscribe(\(subject))"
        }
        else {
            signal = "Signal.representing(stack: Thread.callStackSymbols, userInfo: \(userInfo), source: Source())"
        }
        
        return "\(subject).send(\(signal))"
    }
}
