//
//  Signaling.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

// MARK: - Signaling

/**
 I describe a signaling protocol.

 Conforming objects become `emit()`able, by returning an instance of appropriate `Signal` subclass.

 - Note: Be mindful of the return type as it is also used to determine whether the resulting signal will be logged when `emit()`ing a value.

 For example:
 ````
 class URLRequestSignal: Signal {
    var urlRequest: URLRequest
    init(_ aRequest: URLRequest) {
        urlRequest = aRequest
        super.init()
    }
 }

 extension URLRequest : Signaling {
    var beaconSignal: URLRequestSignal {
        return URLRequestSignal(self)
    }
 }
 ````
 - See Also: `WrapperSignal`
 */
public protocol Signaling {
    associatedtype SignalType: Signal
    var beaconSignal: SignalType { get }
}
