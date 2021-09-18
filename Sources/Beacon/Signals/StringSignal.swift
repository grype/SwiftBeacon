//
//  StringSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/28/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures a string message.
 
 I am used to announce arbitrary messages, ala traditional logging facilities.
 */
open class StringSignal: Signal {
    @objc open private(set) var message: String
    
    @objc public init(_ aMessage: String) {
        message = aMessage
        super.init()
    }
    
    open override var signalName: String { "🏷" }
    
    override open class var portableClassName : String? { "RemoteStringSignal" }
    
    open override var valueDescription: String? {
        return message
    }
    
    // MARK:- Codable
    
    private enum CodingKeys : String , CodingKey {
        case message
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}

/// Emits `StringSignal` with specified value
public func emit(_ value: String, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    emit(value, on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Emits `StringSignal` with specified value
public func emit(_ value: String, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard willLog(type: StringSignal.self, on: beacons) else { return }
    StringSignal(value).emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

extension String : Signaling {
    public var beaconSignal: Signal {
        return StringSignal(self)
    }
}
