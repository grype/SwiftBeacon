//
//  WrapperSignal.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/25/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

public class WrapperSignal: BeaconSignal {
    public let value: Any
    
    public override var signalName: String {
        return "📦 \(String(describing: type(of: value)))"
    }
    
    public init(_ aValue: Any) {
        if let copyTarget = aValue as? NSCopying {
            value = copyTarget.copy(with: nil)
        }
        else {
            value = aValue
        }
        super.init()
    }
    
    public var targetDescription: String {
        if let target = value as? CustomStringConvertible {
            return String(describing: target)
        }
        return "<\(String(describing: type(of: value))): \(Unmanaged.passUnretained(self).toOpaque())>"
    }
    
    public override var description: String {
        return "\(super.description) \(targetDescription)"
    }
}

public func emit(_ value: Any, on aBeacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    WrapperSignal(value).emit(on: aBeacon, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
