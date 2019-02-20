//
//  StackTraceSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/16/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `BeaconSignal` that captures the current call stack.
 
 Simply call `emitStackTrace()` to emit me, and I'll capture the current call stack.
 */
public class StackTraceSignal : ErrorSignal {
    public var stackTrace: [String]
    
    public init(error: Error, stackTrace aStackTrace: [String] = Thread.callStackSymbols) {
        stackTrace = aStackTrace
        super.init(error: error)
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

public func emitStackTrace(error: Error, on aBeacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StackTraceSignal(error: error).emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
