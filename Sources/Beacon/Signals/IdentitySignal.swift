//
//  IdentitySignal.swift
//  
//
//  Created by Pavel Skaldin on 5/4/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures an arbitrary identity.
 
 By default I capture Beacon version. Feel free to extend me...
 */

open class IdentitySignal : Signal {
    
    // MARK:- Properties
    
    public var beaconVersion: String { Beacon.beaconVersion }
    
    lazy public var systemInfo: SystemInfo = { SystemInfo.current }()
    
    // MARK:- Signal
    
    open override var signalName: String {
        return "💡"
    }
    
    open override class var portableClassName: String? { "RemoteIdentitySignal" }
    
    // MARK:- Codable
    
    private enum CodingKeys : String , CodingKey {
        case beaconVersion = "version"
        case systemInfo = "info"
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(beaconVersion, forKey: .beaconVersion)
        try container.encode(systemInfo, forKey: .systemInfo)
    }
    
    // MARK:- Describing
    
    open override var valueDescription: String? { "Beacon/\(beaconVersion) (\(systemInfo))" }
    
}

/// Emits `IdentitySignal`
public func emitIdentity(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    emitIdentity(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Emits `IdentitySignal`
public func emitIdentity(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    guard willLog(type: IdentitySignal.self, on: beacons) else { return }
    IdentitySignal().emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
