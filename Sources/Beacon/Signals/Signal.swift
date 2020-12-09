//
//  Signal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
let UniqueDeviceIdentifier: String? = UIDevice.current.identifierForVendor?.uuidString
#elseif os(macOS)
import IOKit
let UniqueDeviceIdentifier: String? = {
    let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
    let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0);
    IOObjectRelease(platformExpert);
    return serialNumberAsCFString?.takeUnretainedValue() as? String
}()
#else
let UniqueDeviceIdentifier: String? = nil
#endif

/**
 I am an abstract signal.
 
 There exist a few concrete subclasses of me. One of them is `WrapperSignal`, which can wrap
 any object and act as its signal. For everything else I am expected to be subclassed.
 
 My instances are signaled to loggers via `emit()`. Calling `emit()` captures the invocation context
 (using `Signal.Source` struct) and then announces myself via relevant `Beacon` instance.
 
 */
open class Signal : NSObject, Encodable, SignalStringConvertible {
    
    // MARK:- Structs
    
    /// Used to capture `emit()` invocation context
    public struct Source : CustomStringConvertible, Codable {
        var identifier: String? = UniqueDeviceIdentifier
        var module: String?
        var fileName: String
        var line: Int
        var functionName: String?
        
        public init(origin anOrigin: String?, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
            module = anOrigin
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
    
    // MARK:- Class
    
    // MARK: Properties
    
    open class var portableClassName : String? {
        return String(describing: self)
    }
    
    // MARK:- Instance
    
    // MARK: Properties
    
    public enum UserInfoKeys : String {
        case source
    }
    
    /// Source where the signal was `emit()`ed from.
    private(set) var source: Source?
    
    /// User info data passed along by the signaler. 
    @objc open var userInfo: [AnyHashable : Any]?
    
    /// Signal name as appropriate for the instance.
    @objc open var signalName: String {
        let classString = String(describing: type(of: self))
        let suffix = "Signal"
        guard classString.hasSuffix(suffix) else { return classString }
        return String(classString.dropLast(suffix.count))
    }
    
    /// Time when the signal was `emit()`ed.
    @objc public let timestamp: Date = Date()
    
    // MARK: Properties - Private
    
    @objc open lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return dateFormatter
    }()
    
    @objc private(set) lazy var bundleName: String? = {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }()
    
    // MARK:- Emitting
    
    /// Emits signal to all running instances of `SignalLogger`
    @objc open func emit(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        let source = Signal.Source(origin: bundleName, fileName: fileName, line: line, functionName: functionName)
        emit(on: beacons, source: source, userInfo: userInfo)
    }
    
    /// Emits signal to all running instances of `SignalLogger`
    private func emit(on beacons: [Beacon], source aSource: Signal.Source, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        userInfo = anUserInfo
        source = aSource
        beacons.forEach { $0.signal(self) }
    }
    
    // MARK:- Encodable
    
    private enum CodingKeys : String , CodingKey {
        case timestamp, source, userInfo = "properties", portableClassName = "__class"
    }
    
    struct EncodableWrapper: Encodable {
        let wrapped: Encodable

        func encode(to encoder: Encoder) throws {
            try self.wrapped.encode(to: encoder)
        }
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Signal.CodingKeys.self)
        try container.encodeIfPresent(type(of: self).portableClassName, forKey: .portableClassName)
        try container.encodeIfPresent(dateFormatter.string(from: timestamp), forKey: .timestamp)
        try container.encode(source, forKey: .source)
        if let codableInfo = userInfo as? [String : Encodable] {
            let wrapped = codableInfo.mapValues(EncodableWrapper.init(wrapped:))
            try container.encode(wrapped, forKey: .userInfo)
        }
        // Swift is great!
        else if let codableInfo = (userInfo as? [String : AnyHashable]) as? [String : Encodable] {
            let wrapped = codableInfo.mapValues(EncodableWrapper.init(wrapped:))
            try container.encode(wrapped, forKey: .userInfo)
        }
    }
    
    // MARK:- CustomStringConvertible
    
    @objc
    open var signalDescription: String {
        return signalName
    }
    
    @objc
    open var sourceDescription: String? {
        guard let source = source else {
            return nil
        }
        return "\(source)"
    }
    
    @objc
    open var valueDescription: String? {
        return nil
    }
    
    @objc
    open var userInfoDescription: String? {
        guard let userInfo = userInfo else {
            return nil
        }
        return "UserInfo: \(String(reflecting: userInfo))"
    }
    
    @objc
    open var shortDescription: String {
        let dateString = dateFormatter.string(from: timestamp)
        var result = "\(dateString) \(signalDescription)"
        if let sourceDescription = sourceDescription {
            result += " \(sourceDescription)"
        }
        if let valueDescription = valueDescription {
            result += ": \(valueDescription)"
        }
        return result
    }
    
    @objc
    open var longDescription: String {
        var result = shortDescription
        if let userInfoDescription = userInfoDescription {
            result += "\n\(userInfoDescription)"
        }
        return result
    }
    
    @objc
    open override var description: String {
        return shortDescription
    }
    
    @objc
    open override var debugDescription: String {
        return longDescription
    }

}
