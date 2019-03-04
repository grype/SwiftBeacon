//
//  BeaconErrorSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/21/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures an error.
 
 Simply call `emit(anError)` to emit me, and I'll capture the error.
 */
public class ErrorSignal : Signal {
    @objc private(set) var error: Error
    @objc public var stack: [String]
    
    @objc public init(error anError: Error, stack aStack: [String] = Thread.callStackSymbols) {
        error = anError
        stack = aStack
        super.init()
    }
    
    public override var signalName: String {
        return "⚡ \(super.signalName)"
    }
    public override class var portableClassName : String? {
        return "RemoteExceptionSignal"
    }
    
    private enum CodingKeys : String, CodingKey {
        case error = "exception", stack
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: ErrorSignal.CodingKeys.self)
        try container.encode(stack, forKey: .stack)
        if let encodableError = error as? Encodable {
            try encodableError.encode(to: encoder)
        }
        else {
            try container.encode(error.localizedDescription, forKey: .error)
        }
    }
    
    public override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        var result = "\(super.description): \(errorDescription)"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}

public func emit(error: Error, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ErrorSignal(error: error).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

public func emit(error: Error, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ErrorSignal(error: error).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
