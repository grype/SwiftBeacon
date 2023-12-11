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
 (using `Signal.Source` struct) and then announces me via relevant `Beacon` instances.
 
 */

open class Signal: Identifiable, Encodable, CustomStringConvertible, CustomDebugStringConvertible {
    // MARK: - Structs
    
    /// Used to capture `emit()` invocation context
    public struct Source: CustomStringConvertible, Codable {
        public var identifier: String? = UniqueDeviceIdentifier
        public var module: String?
        public var fileName: String
        public var line: Int
        public var functionName: String?
        
        public init(module aModule: String?, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
            module = aModule
            fileName = aFileName
            line = aLine
            functionName = aFunctionName
        }
        
        public var description: String {
            var functionDescription = ""
            if var functionName = functionName {
                if !functionName.hasSuffix(")") {
                    functionName += "()"
                }
                functionDescription = " #\(functionName)"
            }
            let filePrintName = fileName.components(separatedBy: "/").last ?? fileName
            let originName = (module != nil) ? "\(module!)." : ""
            return "[\(originName)\(filePrintName):\(line)]\(functionDescription)"
        }
    }

    // MARK: - Properties
    
    open class var portableClassName: String? {
        return String(describing: self)
    }
    
    // MARK: Properties
    
    /// Source where the signal was `emit()`ed from.
    public var source: Source?
    
    /// User info data passed along by the signaler.
    open var userInfo: [AnyHashable: Any]?
    
    /// Signal name as appropriate for the instance.
    open var signalName: String {
        let classString = String(describing: type(of: self))
        let suffix = "Signal"
        guard classString.hasSuffix(suffix) else { return classString }
        return String(classString.dropLast(suffix.count))
    }
    
    /// Time when the signal was `emit()`ed.
    public let timestamp: Date = .init()
    
    // MARK: Properties - Private
    
    ///
    open lazy var descriptionDateFormatter: DateFormatter = .init(format: .default)
    
    open lazy var bundleName: String? = {
        Bundle.main.infoDictionary?["CFBundleName"] as? String
    }()
    
    // MARK: - Emitting
    
    /// Emits signal to all running instances of `SignalLogger`
    open func emit(on beacons: [Beacon], userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        let source = Signal.Source(module: bundleName, fileName: fileName, line: line, functionName: functionName)
        emit(on: beacons, source: source, userInfo: userInfo)
    }
    
    /// Emits signal to all running instances of `SignalLogger`
    private func emit(on beacons: [Beacon], source aSource: Signal.Source, userInfo anUserInfo: [AnyHashable: Any]? = nil) {
        if let anUserInfo = anUserInfo {
            if let userInfo = userInfo {
                self.userInfo = userInfo.merging(anUserInfo) { _, incoming in incoming }
            }
            else {
                userInfo = anUserInfo
            }
        }
        source = aSource
        beacons.forEach { $0.send(self) }
    }
    
    func sourcedFromHere(fileName: String = #file, line: Int = #line, functionName: String = #function) -> Self {
        source = Signal.Source(module: bundleName, fileName: fileName, line: line, functionName: functionName)
        return self
    }
    
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
