//
//  Signal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am an abstract signal.
 
 There exist a few concrete subclasses of me. One of them is `WrapperSignal`, which can wrap
 any object and act as its signal. For everything else I am expected to be subclassed.
 
 My instances are signaled to loggers via `emit()`. Calling `emit()` captures the invocation context
 (using `Signal.Source` struct) and then announces myself via relevant `Beacon` instance.
 
 */
public class Signal : CustomStringConvertible {
    
    // MARK:- Structs
    
    /// Used to capture `emit()` invocation context
    public struct Source : CustomStringConvertible {
        var fileName: String
        var line: Int
        var functionName: String?
        
        public init(fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
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
            return "[\(filePrintName):\(line)]\(functionDescription)"
        }
    }
    
    // MARK:- Class
    
    // MARK: Properties
    
    /// Default signal name, which is derived from the class name, stripping "Signal" suffix
    public class var signalName: String {
        let classString = String(describing: self)
        let suffix = "Signal"
        guard classString.hasSuffix(suffix) else { return classString }
        return String(classString.dropLast(suffix.count))
    }
    
    // MARK:- Instance
    
    // MARK: Properties
    
    /// Source where the signal was `emit()`ed from.
    public var source: Source?
    
    /// User info data passed along by the signaler. 
    public var userInfo: [AnyHashable : Any]?
    
    /// Signal name as appropriate for the instance. By default this is the same as class-side `signalName`.
    public var signalName: String {
        return type(of: self).signalName
    }
    
    /// Time when the signal was `emit()`ed.
    private(set) var timestamp: Date!
    
    // MARK: Properties - Private
    
    private(set) lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter
    }()
    
    private(set) lazy var bundleName: String = {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }()
    
    // MARK:- Emitting
    
    /// Emits signal to all running instances of `SignalLogger`
    public func emit(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        let source = Signal.Source(fileName: fileName, line: line, functionName: functionName)
        emit(on: beacon, source: source, userInfo: userInfo)
    }
    
    /// Emits signal to all running instances of `SignalLogger`
    public func emit(on beacon: Beacon = Beacon.shared, source aSource: Signal.Source, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        timestamp = Date()
        source = aSource
        userInfo = anUserInfo
        beacon.signal(self)
    }
    
    // MARK:- CustomStringConvertible
    
    public var description: String {
        var sourceDescription = ""
        if let source = source {
            sourceDescription = " \(source)"
        }
        let dateString = dateFormatter.string(from: timestamp)
        return "\(dateString) \(bundleName) \(signalName)\(sourceDescription)"
    }

}

