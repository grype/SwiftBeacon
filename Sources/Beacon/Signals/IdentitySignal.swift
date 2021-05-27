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
        case beaconVersion, systemInfo
    }
    
    // MARK:- Describing
    
    open override var valueDescription: String? { "Beacon \(beaconVersion); \(systemInfo)" }
    
}

/// Emits `IdentitySignal`
public func emitIdentity(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    IdentitySignal().emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Emits `IdentitySignal`
public func emitIdentity(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    IdentitySignal().emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
