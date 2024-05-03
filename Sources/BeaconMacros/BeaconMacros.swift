//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 4/27/24.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct BeaconMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [EmitMacro.self]
}

