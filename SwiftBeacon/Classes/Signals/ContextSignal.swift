//
//  FunctionCallSignal.swift
//  Tweed-iOS
//
//  Created by Pasha on 10/25/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class ContextSignal: BeaconSignal {

    override class var signalName: String {
        return "🌀 \(classSignalName)"
    }
    
    override var description: String {
        return "\(super.description)"
    }
}

func emit(userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
