//
//  BeaconErrorSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/21/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import AnyCodable
import Foundation

// MARK: - ErrorSignal

/**
 I am a `Signal` that captures an error.
 
 Simply call `emit(anError)` to emit me, and I'll capture the error.
 */

open class ErrorSignal: Signal {
    open private(set) var error: Error
    open var stack: [String]
    
    @objc public init(error anError: Error, stack aStack: [String] = Thread.callStackSymbols) {
        error = anError
        stack = aStack
        super.init()
    }
    
    override open var signalName: String { "⚡ \(super.signalName)" }
    
    override open class var portableClassName: String? { "RemoteExceptionSignal" }
    
    private enum CodingKeys: String, CodingKey {
        case error = "exception", stack
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stack.map { CallStackFrame.fromString($0) }, forKey: .stack)
        if let encodableError = error as? Encodable {
            let wrapped = AnyEncodable(encodableError)
            try container.encode(wrapped, forKey: .error)
        }
        else {
            try container.encode(error.localizedDescription, forKey: .error)
        }
    }
    
    var errorDescription: String {
        return (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
    }
    
    override open var description: String {
        var result = "\(super.description): \(errorDescription)"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
    
    override open var debugDescription: String {
        var result = "\(super.description) \(errorDescription)"
        if let userInfoDescription = userInfoDescription {
            result += "\n\(userInfoDescription)"
        }
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}
