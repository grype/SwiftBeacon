//
//  WrapperSignal.swift
//  Tweed-iOS
//
//  Created by Pasha on 10/25/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class WrapperSignal: BeaconSignal {
    let value: Any
    
    override var signalName: String {
        return "📦 \(String(describing: type(of: value)))"
    }
    
    init(_ aValue: Any) {
        if let copyTarget = aValue as? NSCopying {
            value = copyTarget.copy(with: nil)
        }
        else {
            value = aValue
        }
        super.init()
    }
    
    var targetDescription: String {
        if let target = value as? CustomStringConvertible {
            return String(describing: target)
        }
        return "<\(String(describing: type(of: value))): \(Unmanaged.passUnretained(self).toOpaque())>"
    }
    
    override var description: String {
        return "\(super.description) \(targetDescription)"
    }
}

func emit(_ value: Any, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    WrapperSignal(value).emit(userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
