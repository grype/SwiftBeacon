//
//  Beacon.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let BeaconSignal = Notification.Name(rawValue: "BeaconSignal")
}


/**
 I am the central object around signaling.
 
 I maintain a collection of loggers and provide a method for signaling them.
 Before I can be used in a meaningful way, add and start instances of BeaconSignalLogger, like this:
 
 ````
 let logger = BeaconConsoleLogger(name: 'My console logger')
 logger.start()
 Beacon.shared.loggers.append(logger)
 ````
 
 After that, I will announce all signals sent via `signal(_:)` to each logger.
 Loggers are capable of filtering those signals...
 
 ```
 Beacon.shared.signal(WrapperSignal("This is only a string"))
 ```
 
 These are the basic methods of operation, albeit a bit tedious. A simpler approach
 would be to use `emit()`. Instances of `BeaconSignal` understand `emit()`, and there
 are several global emit() functions defined by specific signals...
 
 ```
 emit()     // Emits current context signal
 emit(aBeaconSignalingObject)   // Emits a signal associated with an object that conforms to BeaconSignaling
 emit(error: anError)   // Emits an error signal
 ```
 
 - Note: *I maintain a shared instance, as one instance is generally sufficient, but
 I can be instantiated in traditional ways.*
 
 */
public class Beacon {
    
    public static var shared = Beacon()
    public static let SignalUserInfoKey = "signal"
    
    // MARK:- Properties
    
    internal let announcer = NotificationCenter.default
    
    public var loggers = [BeaconSignalLogger]()
    
    // MARK:- Announcements

    public func signal(_ aSignal: BeaconSignal) {
        announcer.post(name: NSNotification.Name.BeaconSignal,
                       object: self,
                       userInfo: [Beacon.SignalUserInfoKey: aSignal])
    }
    
}
