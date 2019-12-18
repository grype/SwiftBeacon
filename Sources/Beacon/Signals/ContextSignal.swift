//
//  FunctionCallSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures current context.
 
 I am used for announcing a particular point in the code. Simply call `emit()`, without
 any arguments...
 */
open class ContextSignal: Signal {
    @objc open var stack: [String]
    
    @objc public init(stack aStack: [String] = Thread.callStackSymbols) {
        stack = aStack
        super.init()
    }

    open override var signalName: String {
        return "🌀 \(super.signalName)"
    }
    
    open override class var portableClassName : String? {
        return "RemoteContextStackSignal"
    }
    
    private enum CodingKeys : String, CodingKey {
        case stack
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stack.map { CallStackFrame.fromString($0) }, forKey: .stack)
    }
    
    open override var description: String {
        var result = "\(super.description)"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}

/// Signal current context
public func emit(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Signal current context
public func emit(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
