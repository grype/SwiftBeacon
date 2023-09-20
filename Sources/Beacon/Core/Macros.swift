//
//  File.swift
//
//
//  Created by Pavel Skaldin on 6/7/23.
//

import BeaconMacros
import Foundation

@freestanding(expression)
public macro emit<T: Signaling>(_ value: T, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable: Any]? = nil) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")

@freestanding(expression)
public macro emit<T: Signaling>(_ value: T, on beacons: [Beacon], userInfo: [AnyHashable: Any]? = nil) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")
