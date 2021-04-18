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
 
 - Important: Be mindful of what you're asking me to wrap. I'll check to see if the value I am wrapping conforms
 to NSCopying, and if so, I'll store a copy of the value. Otherwise I'll capture the value using regular
 Swift mechanism - by value or reference, depending on the type of value.
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
    
    private var privateValueDescription: String!
    
    private var privateUserInfoDescription: String?
    
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
        privateValueDescription = valueDescription(for: aValue)
        if let userInfo = anUserInfo {
            privateUserInfoDescription = userInfoDescription(for: userInfo)
        }
    }
    
    @objc public init(_ aValue: Any, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        anyValue = aValue
        super.init()
        userInfo = anUserInfo
        privateValueDescription = valueDescription(for: aValue)
        if let userInfo = anUserInfo {
            privateUserInfoDescription = userInfoDescription(for: userInfo)
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case value = "target", valueType = "targetType"
    }
    
    private struct ValueWrapper : Encodable {
        private var value : Encodable
        init(_ aValue: Encodable) {
            value = aValue
        }
        func encode(to encoder: Encoder) throws {
            try value.encode(to: encoder)
        }
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: WrapperSignal.CodingKeys.self)
        
        try container.encode(String(describing: type(of: value)), forKey: .valueType)
        
        if let value = encodableValue {
            try container.encode(ValueWrapper(value), forKey: .value)
        }
        else if let value = value as? CustomDebugStringConvertible {
            try container.encode(value.debugDescription, forKey: .value)
        }
        else {
            try container.encode(String(describing: value), forKey: .value)
        }
    }
    
    // MARK:- Describing
    
    open override var debugDescription: String {
        return "\(super.debugDescription) \(privateValueDescription ?? "")"
    }
    
    @objc
    open func valueDescription(for aValue: Any) -> String {
        return String(reflecting: aValue)
    }
    
    @objc
    open override var userInfoDescription: String? {
        return privateUserInfoDescription
    }
    
    @objc
    func userInfoDescription(for aUserInfo: [AnyHashable : Any]) -> String {
        return String(reflecting: aUserInfo)
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
