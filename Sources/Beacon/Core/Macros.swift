//
//  Macros.swift
//
//
//  Created by Pavel Skaldin on 4/27/24.
//

import Foundation
import Combine

@freestanding(expression)
public macro emit<S:Subject>(_ aValue: Any? = nil, userInfo: Any? = nil, on: S = Beacon) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")

@freestanding(expression)
public macro emit<S:Subject>(error: Error, userInfo: Any? = nil, on: S = Beacon) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")

@freestanding(expression)
public macro emit<V: Signal, S:Subject>(_ aSignal: V, userInfo: Any? = nil, on: S = Beacon) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")

@freestanding(expression)
public macro emit<V: Publisher, S:Subject>(_ aSignal: V, userInfo: Any? = nil, on: S = Beacon) = #externalMacro(module: "BeaconMacros", type: "EmitMacro")
