//
//  Signal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import AnyCodable
import Foundation

/**
 I am an abstract signal.
 
 There exist a few concrete subclasses of me. One of them is `WrapperSignal`, which can wrap
 any object and act as its signal. For everything else I am expected to be subclassed.
 
 My instances are signaled to loggers via `emit()`. Calling `emit()` captures the invocation context
 (using `Signal.Source` struct) and then announces an appropriate instance of a subclass of mine.
 
 */

open class Signal: Identifiable, Encodable, CustomStringConvertible, CustomDebugStringConvertible {
    // MARK: - Properties
    
    open class var portableClassName: String? {
        return String(describing: self)
    }
    
    // MARK: Properties
    
    /// Source where the signal was `emit()`ed from.
    public var source: Source?
    
    /// User info data passed along by the signaler.
    open var userInfo: Any?
    
    /// Signal name as appropriate for the instance.
    open var signalName: String {
        let classString = String(describing: type(of: self))
        let suffix = "Signal"
        guard classString.hasSuffix(suffix) else { return classString }
        return String(classString.dropLast(suffix.count))
    }
    
    /// Time when the signal was `emit()`ed.
    public let timestamp: Date = .init()
    
    // MARK: - Instance Creation
    
    static func representing<S: Signaling>(_ aValue: S, userInfo: Any? = nil, source: Source = .init()) -> some Signal {
        let signal = aValue.beaconSignal
        signal.userInfo = userInfo
        signal.source = source
        return signal
    }
    
    static func representing(_ aValue: Any, userInfo: Any? = nil, source: Source = .init()) -> some Signal {
        let signal = WrapperSignal(aValue)
        signal.userInfo = userInfo
        signal.source = source
        return signal
    }
    
    static func representing(stack aStack: [String] = Thread.callStackSymbols, userInfo: Any? = nil, source: Source = .init()) -> some Signal {
        let signal = ContextSignal(stack: aStack)
        signal.userInfo = userInfo
        signal.source = source
        return signal
    }
    
    static func representing(error anError: Error, stack aStack: [String] = Thread.callStackSymbols, userInfo: Any? = nil, source: Source = .init()) -> some Signal {
        let signal = ErrorSignal(error: anError, stack: aStack)
        signal.userInfo = userInfo
        signal.source = source
        return signal
    }
    
    // MARK: - Initialization
    
    init(userInfo: Any? = nil, source: Source? = nil) {
        self.userInfo = userInfo
        self.source = source
    }
    
    // MARK: Properties - Private
    
    ///
    open lazy var descriptionDateFormatter: DateFormatter = .init(format: .default)
    
    open lazy var bundleName: String? = Bundle.main.infoDictionary?["CFBundleName"] as? String
    
    // MARK: - Encodable
    
    private enum CodingKeys: String, CodingKey {
        case timestamp, source, userInfo = "properties", portableClassName = "__class", description
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type(of: self).portableClassName, forKey: .portableClassName)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encode(source, forKey: .source)
        try container.encode(debugDescription, forKey: .description)
        if let codableInfo = userInfo as? [String: Encodable] {
            let wrapped = codableInfo.mapValues(AnyEncodable.init)
            try container.encode(wrapped, forKey: .userInfo)
        }
        // Swift is great!
        else if let codableInfo = (userInfo as? [String: AnyHashable]) as? [String: Encodable] {
            let wrapped = codableInfo.mapValues(AnyEncodable.init)
            try container.encode(wrapped, forKey: .userInfo)
        }
    }
    
    // MARK: - CustomStringConvertible
    
    open var sourceDescription: String? {
        guard let source = source else {
            return nil
        }
        return "\(source)"
    }
    
    open var userInfoDescription: String? {
        guard let userInfo = userInfo else {
            return nil
        }
        return "\tUserInfo: \(String(reflecting: userInfo))"
    }
    
    open var valueDescription: String? {
        return nil
    }
    
    open var valueDebugDescription: String? {
        return valueDescription
    }
    
    open var description: String {
        let dateString = descriptionDateFormatter.string(from: timestamp)
        var result = "\(dateString) \(signalName)"
        if let sourceDescription = sourceDescription {
            result += " \(sourceDescription)"
        }
        if let valueDescription = valueDescription {
            result += ": \(valueDescription)"
        }
        return result
    }
    
    open var debugDescription: String {
        let dateString = descriptionDateFormatter.string(from: timestamp)
        var result = "\(dateString) \(signalName)"
        if let sourceDescription = sourceDescription {
            result += " \(sourceDescription)"
        }
        if let valueDescription = valueDebugDescription {
            result += ": \(valueDescription)"
        }
        if let userInfoDescription = userInfoDescription {
            result += "\n\(userInfoDescription)"
        }
        return result
    }
}

extension Signal: Equatable {
    public static func == (lhs: Signal, rhs: Signal) -> Bool {
        return lhs === rhs
    }
}
