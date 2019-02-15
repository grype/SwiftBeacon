//
//  BeaconSignal.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

/**
 I am an abstract signal.
 
 There exist a few concrete subclasses of `BeaconSignal`.
 One of those subclasses is `WrapperSignal`, which can wrap
 any object and act as its signal.
 For everything else I am expected to be subclassed.
 
 My instances are signaled to loggers via `emit()`.
 Calling `emit()` captures the invocation context
 (using `BeaconSignal.Source` struct) and then announces
 myself via relevant `Beacon` instance.
 
 */
public class BeaconSignal : CustomStringConvertible {
    
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
    
    public class var classSignalName: String {
        return String(describing: self).replacingOccurrences(of: "Signal", with: "", options: String.CompareOptions.literal, range: nil)
    }
    
    public class var signalName: String {
        return "☀︎ \(classSignalName)"
    }
    
    // MARK:- Instance
    
    // MARK: Properties
    
    public var source: Source?
    public var userInfo: [AnyHashable : Any]?
    
    public var signalName: String {
        return type(of: self).signalName
    }
    
    // MARK: Properties - Private
    
    private(set) var timestamp: Date!
    
    private(set) lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter
    }()
    
    private(set) lazy var bundleName: String = {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }()
    
    // MARK:- Emitting
    
    public func emit(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        let source = BeaconSignal.Source(fileName: fileName, line: line, functionName: functionName)
        emit(on: beacon, userInfo: userInfo, source: source)
    }
    
    public func emit(on beacon: Beacon = Beacon.shared, userInfo anUserInfo: [AnyHashable : Any]? = nil, source aSource: BeaconSignal.Source) {
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

