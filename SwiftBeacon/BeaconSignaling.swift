//
//  BeaconSignaling.swift
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Grype. All rights reserved.
//

import Foundation

/**
 I describe a signaling protocol.
 
 Conforming objects become `emit()`able, by returning an instance of appropriate `BeaconSignal`.
 
 For example:
 ````
 extension UIViewController : BeaconSignaling {
    var beaconSignal: BeaconSignal {
        return ViewControllerSignal(self)
    }
 }
 
 class ViewControllerSignal: BeaconSignal {
    var controller: UIViewController
    init(_ aController: UIViewController) {
        controller = aController
        super.init()
    }
 }
 ````
 
 In similar manner, `WrapperSignal` makes `emit()`able any class or construct...
 
 - See Also: `WrapperSignal`
 
 */
public protocol BeaconSignaling {
    var beaconSignal: BeaconSignal { get }
}

/**
 Emits a signaling object.
 This is a convenience method to emit a signal associated with a `BeaconSignaling` object.
 To be consistent, it is preferred that all logging is done via various `emit()` methods,
 rather than directly interfacing with instances of `BeaconSignal` and `BeaconSignalLogger`.
 */
public func emit(_ value: BeaconSignaling, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: beacon,
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}
