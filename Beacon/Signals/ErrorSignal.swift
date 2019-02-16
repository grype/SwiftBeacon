//
//  BeaconErrorSignal.swift
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 10/21/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

/**
 I am a `BeaconSignal` that captures an error.
 
 Simply call `emit(anError)` to emit me, and I'll capture the error.
 */
public class ErrorSignal : BeaconSignal {
    private(set) var error: Error
    
    public init(error anError: Error) {
        error = anError
        super.init()
    }
    
    public override var signalName: String {
        return "⚡ \(super.signalName)"
    }
    
    public override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        let result = "\(super.description): \(errorDescription)"
        return result
    }
}

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
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        var result = "\(super.description): \(errorDescription)"
        stackTrace.forEach { result.append("\n\($0)") }
        return result
    }
}

public func emit(on aBeacon: Beacon = Beacon.shared, error: Error, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ErrorSignal(error: error).emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

public func emitStackTrace(on aBeacon: Beacon = Beacon.shared, error: Error, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StackTraceSignal(error: error).emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
