//
//  StringSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/28/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

public class StringSignal: Signal {
    @objc public private(set) var message: String
    
    @objc public init(_ aMessage: String) {
        message = aMessage
        super.init()
    }
    
    public override var signalName: String {
        return "🏷"
    }
    
    override public class var portableClassName : String? {
        return "RemoteStringSignal"
    }
    
    private enum CodingKeys : String , CodingKey {
        case message
    }
    
    public override var description: String {
        let userInfoDescription : String!
        if let userInfo = userInfo {
            userInfoDescription = "\nUserInfo: \(userInfo.debugDescription)".replacingOccurrences(of: "\n", with: "\n\t")
        }
        else {
            userInfoDescription = ""
        }
        let result = "\(super.description): \(message)\(userInfoDescription!)"
        return result
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: StringSignal.CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: String, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StringSignal(value).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Wraps any value into WrapperSignal and emits the resulting signal
public func emit(_ value: String, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    StringSignal(value).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

extension String : Signaling {
    public var beaconSignal: Signal {
        return StringSignal(self)
    }
}
