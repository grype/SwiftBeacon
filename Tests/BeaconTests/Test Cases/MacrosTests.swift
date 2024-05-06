//
//  MacrosTests.swift
//
//
//  Created by Pavel Skaldin on 4/29/24.
//

import BeaconMacros
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class MacrosTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmitContextOverImplicitSubject() throws {
        assertMacroExpansion("""
                             #emit()
                             """,
                             expandedSource: """
                             Beacon.send(Signal.representing(stack: Thread.callStackSymbols, userInfo: nil, source: Source()))
                             """,
                             macros: ["emit": EmitMacro.self])
    }

    func testEmitContextOverExplicitSubject() throws {
        assertMacroExpansion("""
                             #emit(on: aSubject)
                             """,
                             expandedSource: """
                             aSubject.send(Signal.representing(stack: Thread.callStackSymbols, userInfo: nil, source: Source()))
                             """,
                             macros: ["emit": EmitMacro.self])
    }

    func testEmitContextWithUserInfoOverExplicitSubject() throws {
        assertMacroExpansion("""
                             #emit(userInfo: ["bool": true], on: aSubject)
                             """,
                             expandedSource: """
                             aSubject.send(Signal.representing(stack: Thread.callStackSymbols, userInfo: ["bool": true], source: Source()))
                             """,
                             macros: ["emit": EmitMacro.self])
    }

    func testEmitContextWithUserInfoOverImplicitSubject() throws {
        assertMacroExpansion("""
                             #emit(userInfo: ["bool": true])
                             """,
                             expandedSource: """
                             Beacon.send(Signal.representing(stack: Thread.callStackSymbols, userInfo: ["bool": true], source: Source()))
                             """,
                             macros: ["emit": EmitMacro.self])
    }
    
    func testEmitSignalOverImplicitSubject() throws {
        assertMacroExpansion("""
                             #emit(signal: StringSignal("String signal"))
                             """,
                             expandedSource: """
                             Beacon.send(StringSignal("String signal"))
                             """,
                             macros: ["emit": EmitMacro.self])
    }
    
    func testEmitSignalOverExplicitSubject() throws {
        assertMacroExpansion("""
                             #emit(signal: StringSignal("String signal"), on: aSubject)
                             """,
                             expandedSource: """
                             aSubject.send(StringSignal("String signal"))
                             """,
                             macros: ["emit": EmitMacro.self])
    }
}
