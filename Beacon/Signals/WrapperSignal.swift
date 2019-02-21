//
//  WrapperSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that wraps any value.
 
 Simply call `emit(anything)` to emit me, and I'll capture the argument in my `value` property.
 
 - Important: Be mindful of what you're asking me to wrap. I'll check to see if the value I am wrapping conforms
 to NSCopying, and if so, I'll store a copy of the value. Otherwise I'll capture the value using regular
 Swift mechanism - by value or reference, depending on the type of value.
 */
public class WrapperSignal: Signal {
    /// Wrapped value
    public let value: Any
    
    public override var signalName: String {
        return "📦 \(String(describing: type(of: value)))"
    }
    
    public init(_ aValue: Any) {
        if let copyTarget = aValue as? NSCopying {
            value = copyTarget.copy(with: nil)
        }
        else {
            value = aValue
        }
        super.init()
    }
    
    public var valueDescription: String {
        if let value = value as? CustomStringConvertible {
            return String(describing: value)
        }
        return "<\(String(describing: type(of: value))): \(Unmanaged.passUnretained(self).toOpaque())>"
    }
    
    public override var description: String {
        return "\(super.description) \(valueDescription)"
    }
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    WrapperSignal(value).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    WrapperSignal(value).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
