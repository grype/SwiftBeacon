//
//  BeaconErrorSignal.swift
//  Tweed-iOS
//
//  Created by Pasha on 10/21/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class ErrorSignal : BeaconSignal {
    var error: Error
    
    init(error anError: Error) {
        error = anError
        super.init()
    }
    
    override class var signalName: String {
        return "⚡ \(classSignalName)"
    }
    
    override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        let result = "\(super.description): \(errorDescription)"
        return result
    }
}

class StackTraceSignal : ErrorSignal {
    var stackTrace: [String]
    
    init(error: Error, stackTrace aStackTrace: [String] = Thread.callStackSymbols) {
        stackTrace = aStackTrace
        super.init(error: error)
    }
    
    override class var signalName: String {
        return "💣 \(classSignalName)"
    }
    
    override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        var result = "\(super.description): \(errorDescription)"
        stackTrace.forEach { result.append("\n\($0)") }
        return result
    }
}

func emit(error: Error, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ErrorSignal(error: error).emit(userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

func emitStackTrace(error: Error, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StackTraceSignal(error: error).emit(userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
