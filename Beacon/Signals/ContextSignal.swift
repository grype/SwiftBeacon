//
//  FunctionCallSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures current context.
 
 I am used for announcing a particular point in the code. Simply call `emit()`, without
 any arguments...
 */
public class ContextSignal: Signal {

    public override var signalName: String {
        return "🌀 \(super.signalName)"
    }
    
    public override var description: String {
        return "\(super.description)"
    }
}

/// Signal current context
public func emit(on aBeacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
