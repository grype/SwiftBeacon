//
//  IdentitySignal.swift
//
//
//  Created by Pavel Skaldin on 5/4/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

// MARK: - IdentitySignal

/**
 I am a `Signal` that captures an arbitrary identity.
 
 By default I capture Beacon version. Feel free to extend me...
 */

open class IdentitySignal: Signal {
    // MARK: - Properties
    
    public lazy var systemInfo: SystemInfo = .current
    
    // MARK: - Signal
    
    override open var signalName: String { "💡" }
    
    override open class var portableClassName: String? { "RemoteIdentitySignal" }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case systemInfo = "info"
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(systemInfo, forKey: .systemInfo)
    }
    
    // MARK: - Describing
    
    override open var valueDescription: String? { "\(systemInfo)" }
}
