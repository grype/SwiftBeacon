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

// MARK: - Globals

/**
 Emits a signaling object.
 This is a convenience method to emit a signal associated with a `Signaling` object.
 To be consistent, it is preferred that all logging is done via various `emit()` methods,
 rather than directly interfacing with instances of `Signal` and `SignalLogger`.
 */
public func emit<T: Signaling>(_ value: T, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: [beacon],
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}

/**
 Emits a signaling object.
 This is a convenience method to emit a signal associated with a `Signaling` object.
 To be consistent, it is preferred that all logging is done via various `emit()` methods,
 rather than directly interfacing with instances of `Signal` and `SignalLogger`.
 */
public func emit<T: Signaling>(_ value: T, on beacons: [Beacon], userInfo: [AnyHashable: Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: beacons,
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}
