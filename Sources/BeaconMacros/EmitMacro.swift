//
//  File.swift
//
//
//  Created by Pavel Skaldin on 6/7/23.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EmitMacro: ExpressionMacro {
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node: SwiftSyntax.FreestandingMacroExpansionSyntax, Context: SwiftSyntaxMacros.MacroExpansionContext {
        guard let value = node.argumentList.first?.expression else {
            fatalError("value is required")
        }
        
        var beacons: ExprSyntax!
        if node.argumentList.count > 1 {
            beacons = node.argumentList[node.argumentList.index(after: node.argumentList.startIndex)].expression
        }
        else {
            beacons = ""
        }

        var userInfo: ExprSyntax!
        if node.argumentList.count > 2 {
            userInfo = node.argumentList.last?.expression
        }
        else {
            userInfo = ""
        }
        
        return
"""
if willEmit(type: type(of: \(value)).SignalType, on: \(beacons)) {
    \(value).beaconSignal.emit(on: \(beacons), userInfo: \(userInfo), fileName: #fileName, line: #line, functionName: #functionName)
}
"""
    }
}

@main
struct BeaconMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [EmitMacro.self]
}
