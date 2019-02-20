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
 extension UIViewController : Signaling {
    var beaconSignal: Signal {
        return ViewControllerSignal(self)
    }
 }
 
 class ViewControllerSignal: Signal {
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
public protocol Signaling {
    var beaconSignal: Signal { get }
}

/**
 Emits a signaling object.
 This is a convenience method to emit a signal associated with a `Signaling` object.
 To be consistent, it is preferred that all logging is done via various `emit()` methods,
 rather than directly interfacing with instances of `Signal` and `SignalLogger`.
 */
public func emit(_ value: Signaling, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: beacon,
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}
