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
 
 I maintain a collection of loggers and provide a method for signaling them.
 Before I can be used in a meaningful way, add and start instances of SignalLogger, like this:
 
 ````
 let logger = ConsoleLogger(name: 'My console logger')
 logger.start()
 Beacon.shared.loggers.append(logger)
 
 // or in shorter form:
 Beacon.shared.add(ConsoleLogger(name: 'My console logger', start: true))
 ````
 
 After that, I will announce all signals sent via `signal(_:)` to each logger.
 
 ````
 Beacon.shared.signal(WrapperSignal("This is only a string"))
 ````
 
 It is up to individual loggers to decide whether and how to handle each signal.
 
 These are the basic methods of operation, albeit a bit tedious. A simpler approach
 would be to use `emit()`. Instances of `Signal` understand `emit()`, and there
 are several global emit() functions defined by specific signals...
 
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
public class Beacon : Hashable {
    
    public static var shared = Beacon()
    public static let SignalUserInfoKey = "signal"
    
    // MARK:- Properties
    
    internal let announcer = NotificationCenter.default
    
    // MARK:- Announcements

    public func signal(_ aSignal: Signal) {
        announcer.post(name: NSNotification.Name.BeaconSignal,
                       object: self,
                       userInfo: [Beacon.SignalUserInfoKey: aSignal])
    }
    
    // MARK:- Hashable
    
    public static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}
