//
//  StackTraceSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/16/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures the current call stack.
 
 Simply call `emitStackTrace()` to emit me, and I'll capture the current call stack.
 */
@available(*, deprecated)
public class StackTraceSignal : Signal {
    @objc public var stackTrace: [String]
    
    @objc public init(stackTrace aStackTrace: [String] = Thread.callStackSymbols) {
        stackTrace = aStackTrace
        super.init()
    }
    
    public override var signalName: String {
        return "💣 \(super.signalName)"
    }
    
    public override var description: String {
        var result = super.description
        stackTrace.forEach { result.append("\n\($0)") }
        return result
    }
}

public func emitStackTrace(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StackTraceSignal().emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

public func emitStackTrace(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StackTraceSignal().emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
