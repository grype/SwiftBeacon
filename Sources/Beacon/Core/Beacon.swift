//
//  Beacon.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

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

open class Beacon: NSObject, Subject {
    public typealias Output = Signal
    
    public typealias Failure = Never
    
    @objc public static var beaconVersion = "2.1.4"
    
    /// Shared general-purpose instance
    @objc public static var shared = Beacon()
    
    private var passthroughSubject: PassthroughSubject<Output, Failure> = .init()
    
    public func send(_ value: Signal) {
        passthroughSubject.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Never>) {
        passthroughSubject.send(completion: completion)
    }
    
    public func send(subscription: Subscription) {
        passthroughSubject.send(subscription: subscription)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input {
        passthroughSubject.receive(subscriber: subscriber)
    }
}
