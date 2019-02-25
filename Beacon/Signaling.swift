//
//  Signaling.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I describe a signaling protocol.
 
 Conforming objects become `emit()`able, by returning an instance of appropriate `Signal`.
 
 For example:
 ````
 extension URLRequest : Signaling {
    var beaconSignal: Signal {
        return URLRequestSignal(self)
    }
 }
 
 class URLRequestSignal: Signal {
    var urlRequest: URLRequest
    init(_ aRequest: URLRequest) {
        urlRequest = aRequest
        super.init()
    }
 }
 ````
 
 In similar manner, `WrapperSignal` makes `emit()`able any class or construct...
 
 - See Also: `WrapperSignal`
 
 */
@objc public protocol Signaling {
    var beaconSignal: Signal { get }
}

/**
 Emits a signaling object.
 This is a convenience method to emit a signal associated with a `Signaling` object.
 To be consistent, it is preferred that all logging is done via various `emit()` methods,
 rather than directly interfacing with instances of `Signal` and `SignalLogger`.
 */
public func emit(_ value: Signaling, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
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
public func emit(_ value: Signaling, on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: beacons,
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}
