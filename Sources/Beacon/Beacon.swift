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
 I am the central object around signaling and provide an interface for notifying subscribed loggers with signals.
 
 I utilize NotificationCenter to post notification about the signals I receive. Subscribed loggers decide whether and how to handle a signal.
 
 ````
 let logger = ConsoleLogger(named: "My Console Logger")
 logger.start(on: [aBeacon])
 
 emit(on: [aBeacon])     // Emits current context signal
 emit(aSignalingObject, on: [eBeacon])   // Emits a signal associated with an object that conforms to Signaling
 emit(error: anError, on: [aBeacon])   // Emits an error signal
 
 logger.stop(on: [aBeacon])
 ````
 
 I also provide a shared general-purpose instance, as a single instance is sufficient in most cases.
 Omitting a beacon when starting a logger or emitting a signal implies this shared instance:
 
 ````
 let logger = ConsoleLogger(named: "My Console Logger")
 logger.run {
    emit()
 }
 ````
 
 */
open class Beacon : NSObject {
    
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

    @objc public func signal(_ aSignal: Signal) {
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
