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
    
    override open var signalName: String { "🏷" }
    
    override open class var portableClassName: String? { "RemoteStringSignal" }
    
    override open var valueDescription: String? {
        return message
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}

extension String: Signaling {
    public var beaconSignal: StringSignal {
        return StringSignal(self)
    }
}
