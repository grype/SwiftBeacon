//
//  FunctionCallSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import MachO

// MARK: - ContextSignal

/**
 I am a `Signal` that captures current context.

 I am used for announcing a particular point in the code. Simply call `emit()`, without
 any arguments...
 */

open class ContextSignal: Signal {
    @objc open var stack: [String]

    @objc open var symbols: [String: [Int]]

    @objc public init(stack aStack: [String] = Thread.callStackSymbols) {
        stack = aStack
        symbols = [String: [Int]]()
        for i in 0 ..< _dyld_image_count() {
            let name = String(cString: _dyld_get_image_name(i))
            let header = Int(bitPattern: _dyld_get_image_header(i))
            let slide = _dyld_get_image_vmaddr_slide(i)
            symbols[name] = [header, slide]
        }
        super.init()
    }

    override open var signalName: String { "🌀 \(super.signalName)" }

    override open class var portableClassName: String? { "RemoteContextStackSignal" }

    private enum CodingKeys: String, CodingKey {
        case stack, symbols
    }

    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stack.map { CallStackFrame.fromString($0) }, forKey: .stack)
        try container.encode(symbols, forKey: .symbols)
    }

    override open var debugDescription: String {
        var result = super.debugDescription
        result += "\nStack:"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}

// MARK: - Globals

/// Signal current context
public func emit(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard willLog(type: ContextSignal.self, on: beacon) else { return }
    ContextSignal().emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Signal current context
public func emit(on beacons: [Beacon], userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    beacons.forEach { aBeacon in
        emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
    }
}
