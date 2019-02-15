//
//  BeaconErrorSignal.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/21/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

public class ErrorSignal : BeaconSignal {
    public var error: Error
    
    public init(error anError: Error) {
        error = anError
        super.init()
    }
    
    public override class var signalName: String {
        return "⚡ \(classSignalName)"
    }
    
    public override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        let result = "\(super.description): \(errorDescription)"
        return result
    }
}

public class StackTraceSignal : ErrorSignal {
    public var stackTrace: [String]
    
    public init(error: Error, stackTrace aStackTrace: [String] = Thread.callStackSymbols) {
        stackTrace = aStackTrace
        super.init(error: error)
    }
    
    public override class var signalName: String {
        return "💣 \(classSignalName)"
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
