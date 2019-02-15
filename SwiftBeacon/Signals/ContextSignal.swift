//
//  FunctionCallSignal.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/25/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

public class ContextSignal: BeaconSignal {

    public override class var signalName: String {
        return "🌀 \(classSignalName)"
    }
    
    public override var description: String {
        return "\(super.description)"
    }
}

public func emit(on aBeacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
