//
//  BeaconErrorSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/21/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures an error.
 
 Simply call `emit(anError)` to emit me, and I'll capture the error.
 */
open class ErrorSignal : Signal {
    @objc private(set) var error: Error
    @objc open var stack: [String]
    
    @objc public init(error anError: Error, stack aStack: [String] = Thread.callStackSymbols) {
        error = anError
        stack = aStack
        super.init()
    }
    
    open override var signalName: String {
        return "⚡ \(super.signalName)"
    }
    open override class var portableClassName : String? {
        return "RemoteExceptionSignal"
    }
    
    private enum CodingKeys : String, CodingKey {
        case error = "exception", stack
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: ErrorSignal.CodingKeys.self)
        try container.encode(stack.map { CallStackFrame.fromString($0) }, forKey: .stack)
        if let encodableError = error as? Encodable {
            let wrapped = EncodableWrapper.init(wrapped:encodableError)
            try container.encode(wrapped, forKey: .error)
        }
        else {
            try container.encode(error.localizedDescription, forKey: .error)
        }
    }
    
    var errorDescription: String {
        return (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
    }
    
    open override var description: String {
        var result = "\(super.description): \(errorDescription)"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
    
    open override var debugDescription: String {
        var result = "\(super.description) \(errorDescription)"
        if let userInfoDescription = userInfoDescription {
            result += "\n\(userInfoDescription)"
        }
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}

/**
 In the event of non-nil error argument, emits an ErrorSignal. Otherwise - ContextSignal.
 
 This methods exists in order to distinguish objects that conform to Error. Calling emit(value) will
 wrap that value in a WrapperSignal. This may not be desired when the value conforms to Error. The optionality
 of the error argument is solely for convenience, so as to avoid having to check optional error values and
 introducing if/else statements all over the code.
*/
public func emit(error: Error?, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard let error = error else {
        emit(on: beacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
        return
    }
    ErrorSignal(error: error).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/**
 In the event of non-nil error argument, emits an ErrorSignal. Otherwise - ContextSignal.
 
 This methods exists in order to distinguish objects that conform to Error. Calling emit(value) will
 wrap that value in a WrapperSignal. This may not be desired when the value conforms to Error. The optionality
 of the error argument is solely for convenience, so as to avoid having to check optional error values and
 introducing if/else statements all over the code.
 */
public func emit(error: Error?, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard let error = error else {
        emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
        return
    }
    ErrorSignal(error: error).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
