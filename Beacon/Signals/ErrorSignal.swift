//
//  BeaconErrorSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/21/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures an error.
 
 Simply call `emit(anError)` to emit me, and I'll capture the error.
 */
public class ErrorSignal : Signal {
    private(set) var error: Error
    
    public init(error anError: Error) {
        error = anError
        super.init()
    }
    
    public override var signalName: String {
        return "⚡ \(super.signalName)"
    }
    
    public override var description: String {
        let errorDescription = (type(of: error) == NSError.self) ? error.localizedDescription : String(describing: error)
        let result = "\(super.description): \(errorDescription)"
        return result
    }
}

public func emit(error: Error, on aBeacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ErrorSignal(error: error).emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
