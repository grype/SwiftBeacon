//
//  WrapperSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that wraps any value.
 
 Simply call `emit(anything)` to emit me, and I'll capture the argument in my `value` property.
 
 - Important: Be mindful of what you're asking me to wrap. If the value is mutable, it may mutate by the time it is logged. Especially when using `IntervalLogger`s.
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
    
    open override var signalName: String {
        return "📦"
    }
    
    override open class var portableClassName : String? {
        return "RemoteWrapperSignal"
    }
    
    public init(_ aValue: Encodable, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        encodableValue = aValue
        super.init()
        userInfo = anUserInfo
    }
    
    @objc public init(_ aValue: Any, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        anyValue = aValue
        super.init()
        userInfo = anUserInfo
    }
    
    private enum CodingKeys : String, CodingKey {
        case value = "target", valueType = "targetType"
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: WrapperSignal.CodingKeys.self)
        
        try container.encode(String(describing: type(of: value)), forKey: .valueType)
        
        if let value = value as? CustomDebugStringConvertible {
            try container.encode(value.debugDescription, forKey: .value)
        }
        else {
            try container.encode(String(describing: value), forKey: .value)
        }
    }

}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    emit(value, on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: Any, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard willLog(type: WrapperSignal.self, on: beacons) else { return }
    WrapperSignal(value).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
