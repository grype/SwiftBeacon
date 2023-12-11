//
//  WrapperSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import AnyCodable
import Foundation

// MARK: - WrapperSignal

/**
 I am a `Signal` that wraps any value.
 
 Simply call `emit(anything)` to emit me, and I'll capture the argument in my `value` property.
 
 - Note: If the wrapped value is `Encodable`, I'll be able to encode it along with other properties!
 
 - Important: Be mindful of what you're asking me to wrap. If the value is mutable, it may mutate by the time it is logged. Especially when using `IntervalLogger`s. If state is important, consider signaling either a copy of the object or encode it into `Data`. Otherwise, subclass either me or `Signal` and take care of preserving state there.
 */

open class WrapperSignal: Signal {
    /// Wrapped value
    @objc open var value: Any {
        if let encodable = encodableValue {
            return encodable
        }
        return anyValue!
    }
    
    private var anyValue: Any?
    
    private var encodableValue: Encodable?
    
    override open var signalName: String { "📦" }
    
    override open class var portableClassName: String? { "RemoteWrapperSignal" }
    
    public init(_ aValue: Encodable, userInfo anUserInfo: [AnyHashable: Any]? = nil) {
        encodableValue = aValue
        super.init()
        userInfo = anUserInfo
    }
    
    @objc public init(_ aValue: Any, userInfo anUserInfo: [AnyHashable: Any]? = nil) {
        anyValue = aValue
        super.init()
        userInfo = anUserInfo
    }
    
    private enum CodingKeys: String, CodingKey {
        case value = "target", valueType = "targetType"
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(describing: type(of: value)), forKey: .valueType)
        
        if let value = encodableValue {
            try container.encode(AnyCodable(value), forKey: .value)
        }
        else if let value = value as? CustomDebugStringConvertible {
            try container.encode(value.debugDescription, forKey: .value)
        }
        else {
            try container.encode(String(describing: value), forKey: .value)
        }
    }
    
    override open var valueDescription: String? {
        return "\(value)"
    }
}

// MARK: - Globals

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    WrapperSignal(value).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacons: [Beacon], userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    beacons.forEach { aBeacon in
        emit(value, on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
    }
}
