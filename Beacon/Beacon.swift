//
//  Beacon.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let BeaconSignal = Notification.Name(rawValue: "BeaconSignal")
}


/**
 I am the central object around signaling.
 
 I provide an interface for notifying subscribed loggers with signals:
 
 ````
 Beacon.shared.signal(WrapperSignal("This is only a string"))
 ````
 
 It is up to the logger to decide whether and how to handle a signal.
 
 While this is the most direct way to emit signals, a more succinct way is using `emit()`:
 
 ````
 emit()     // Emits current context signal
 emit(aSignalingObject)   // Emits a signal associated with an object that conforms to Signaling
 emit(error: anError)   // Emits an error signal
 ````
 
 - Note: *I maintain a shared instance, as one instance is generally sufficient.
 If you require multiple beacon objects, be sure to include the appropriate object
 when calling emit:*
 
 ````
 emit(something, on: myBeaconObject)
 ````
 
 */
public class Beacon : NSObject {
    
    /// Shared general-purpose instance
    @objc public static var shared = Beacon()
    @objc internal static let SignalUserInfoKey = "BeaconSignal"
    
    // MARK:- Properties
    
    internal let announcer = NotificationCenter.default
    
    @objc private(set) var queue: OperationQueue!
    
    @objc public init(queue aQueue: OperationQueue? = OperationQueue.current) {
        queue = aQueue ?? OperationQueue.main
    }
    
    // MARK:- Announcements

    @objc internal func signal(_ aSignal: Signal) {
        announcer.post(name: NSNotification.Name.BeaconSignal,
                       object: self,
                       userInfo: [Beacon.SignalUserInfoKey: aSignal])
    }
    
}

public func +(lhs: Beacon, rhs: Beacon) -> [Beacon] {
    return [lhs, rhs]
}

public func +(lhs: [Beacon], rhs: Beacon) -> [Beacon] {
    var result = [Beacon]()
    result.append(contentsOf: lhs)
    result.append(rhs)
    return result
}

public func +(lhs: Beacon, rhs: [Beacon]) -> [Beacon] {
    var result = [Beacon]()
    result.append(lhs)
    result.append(contentsOf: rhs)
    return result
}

public func +(lhs: [Beacon], rhs: [Beacon]) -> [Beacon] {
    var result = [Beacon]()
    result.append(contentsOf: lhs)
    result.append(contentsOf: rhs)
    return result
}
