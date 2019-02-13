//
//  BeaconSignal.swift
//  Tweed-iOS
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class BeaconSignal : CustomStringConvertible {
    
    // MARK:- Structs
    
    struct Source : CustomStringConvertible {
        var fileName: String
        var line: Int
        var functionName: String?
        
        init(fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
            fileName = aFileName
            line = aLine
            functionName = aFunctionName
        }
        
        var description: String {
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
    
    class var classSignalName: String {
        return String(describing: self).replacingOccurrences(of: "Signal", with: "", options: String.CompareOptions.literal, range: nil)
    }
    
    class var signalName: String {
        return "☀︎ \(classSignalName)"
    }
    
    // MARK:- Instance
    
    // MARK: Properties
    
    private(set) var timestamp: Date!
    var source: Source?
    var userInfo: [AnyHashable : Any]?
    
    var signalName: String {
        return type(of: self).signalName
    }
    
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
    
    func emit(userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        timestamp = Date()
        self.source = BeaconSignal.Source(fileName: fileName, line: line, functionName: functionName)
        self.userInfo = userInfo
        Beacon.shared.announce(self)
    }
    
    // MARK:- CustomStringConvertible
    
    var description: String {
        var sourceDescription = ""
        if let source = source {
            sourceDescription = " \(source)"
        }
        let dateString = dateFormatter.string(from: timestamp)
        return "\(dateString) \(bundleName) \(signalName)\(sourceDescription)"
    }

}

