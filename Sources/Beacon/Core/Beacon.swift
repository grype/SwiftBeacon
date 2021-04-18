//
//  Beacon.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import SwiftAnnouncements


/**
 I am the central object around signaling and provide an interface for notifying subscribed loggers with signals.
 
 I utilize `Announcer` to post notification about the signals I receive. Subscribed loggers decide whether and how to handle a signal.
 
 ````
 let beacon = Beacon()
 let logger = ConsoleLogger(named: "My Console Logger")
 logger.start(on: [beacon])
 
 emit(on: [beacon])     // Emits current context signal
 emit(aSignalingObject, on: [beacon])   // Emits a signal associated with an object that conforms to Signaling
 emit(error: anError, on: [beacon])   // Emits an error signal
 
 logger.stop(on: [beacon])
 ````
 
 I also provide a shared general-purpose instance, as a single instance is sufficient in most cases.
 Omitting a beacon when starting a logger or emitting a signal implies this shared instance. Along with a shorthand for logging, the above can be rewritten as:
 
 ````
 let logger = ConsoleLogger(named: "My Console Logger")
 logger.run {
    emit()
    emit(aSignalingObject)
    emit(error: anError)
 }
 ````
 
 */
open class Beacon : NSObject {
    
    /// Shared general-purpose instance
    @objc public static var shared = Beacon()
    
    // MARK:- Properties
    
    internal let announcer = Announcer()
    
    // MARK:- Announcements

    @objc open func signal(_ aSignal: Signal) {
        announcer.announce(aSignal)
    }
    
    open func when<T: Announceable>(_ aType: T.Type, subscriber: AnyObject? = nil, do aBlock: @escaping (T, Announcer)->Void) {
        announcer.when(aType, subscriber: subscriber, do: aBlock)
    }
    
    open func remove<T: Announceable>(subscription: Subscription<T>) {
        announcer.remove(subscription: subscription)
    }
    
    open func unsubscribe(_ anObject: AnyObject) {
        announcer.unsubscribe(anObject)
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
