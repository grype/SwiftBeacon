//
//  SignalLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am an abstract logger of `Signal`s.
 
 There exist a few concrete subclasses of me, like `ConsoleLogger` and `MemoryLogger`.
 
 I carry a `name` to disinguish myself from other loggers. I also keep a reference to the `Beacon`
 on which I observe signals, defaulting to `Beacon.shared` instance.
 
 # Subclassing notes
 
 - At the bare minumum, override `nextPut(_:)`. In that method, take care of handling the signal.
 - Override `nextPutAll(_:)` if special care is needed when handling multiple signals.
 - Override `description` for customizing my description.
 
 - See Also: `ConsoleLogger`, `MemoryLogger`
 */
public class SignalLogger : NSObject {
    
    /// Logger name.
    /// Used to distinguish one logger from another.
    @objc public var name: String
    
    /// Indicates whether the logger is running.
    /// When running, it will respond to signals posted to its beacon's announcer.
    @objc var isRunning : Bool {
        return !observedBeacons.isEmpty
    }
    
    /// Filtering function takes a signal as an argument and return a boolean value
    /// indicating whether the signal should be processed
    public typealias Filter = (Signal)->Bool
    
    private struct BeaconObservationToken : Hashable {
        static func == (lhs: SignalLogger.BeaconObservationToken, rhs: SignalLogger.BeaconObservationToken) -> Bool {
            return lhs.data.hash == rhs.data.hash
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(data.hash)
        }
        
        var data : NSObjectProtocol
    }
    
    /// Array of all observed beacons
    private var observedBeacons = [Beacon : NSObjectProtocol]()
    
    public class func starting<T:SignalLogger>(name aName: String, on beacon: Beacon = Beacon.shared, filter: Filter? = nil) -> T {
        let me = self.init(name: aName)
        me.subscribe(to: beacon, filter: filter)
        return me as! T
    }
    
    public class func starting<T:SignalLogger>(name aName: String, on beacons: [Beacon], filter: Filter? = nil) -> T {
        let me = self.init(name: aName)
        me.subscribe(to: beacons, filter: filter)
        return me as! T
    }
    
    // MARK:- Init/Deinit
    
    @objc public required init(name aName: String) {
        name = aName
    }
    
    deinit {
        stop()
    }
    
    // MARK:- Starting/Stopping
    
    /// Starts logging.
    /// This causes the logger to subscribe to signals posted by specified beacon.
    @objc public func start(on aBeacon: Beacon = Beacon.shared, filter aFilter: Filter? = nil) {
        subscribe(to: aBeacon, filter: aFilter)
    }
    
    /// Stops logging.
    @objc public func stop(on beacon: Beacon? = nil) {
        if let beacon = beacon {
            unsubscribe(from: beacon)
        }
        else {
            unsubscribeFromAllBeacons()
        }
    }
    
    // MARK:- Signaling
    
    /// Processes a signal.
    @objc public func nextPut(_ aSignal: Signal) {
        fatalError("Subclass must override \(#function)")
    }
    
    /// Process signals in bulk.
    @objc public func nextPutAll(_ signals: [Signal]) {
        signals.forEach { (aSignal) in
            nextPut(aSignal)
        }
    }
    
    // MARK:- Processing signals
    
    private func process(_ signal: Signal) {
        nextPut(signal)
    }
    
    // MARK:- Un/Subscribing
    
    private func subscribe(to aBeacon: Beacon, filter: Filter? = nil) {
        subscribe(to: [aBeacon], filter: filter)
    }
    
    private func subscribe(to beacons: [Beacon], filter: Filter? = nil) {
        objc_sync_enter(observedBeacons)
        beacons.forEach { (aBeacon) in
            if let index = observedBeacons.index(forKey: aBeacon) {
                aBeacon.announcer.removeObserver(observedBeacons.remove(at: index).value)
            }
            let token = aBeacon.announcer.addObserver(forName: .BeaconSignal, object: aBeacon, queue: aBeacon.queue) { [weak self] (aNotification) in
                guard let self = self, let signal = aNotification.beaconSignal else { return }
                guard filter == nil || filter!(signal) else { return }
                self.process(signal)
            }
            observedBeacons[aBeacon] = token
        }
        objc_sync_exit(observedBeacons)
    }
    
    private func unsubscribe(from aBeacon: Beacon) {
        unsubscribe(from: [aBeacon])
    }
    
    private func unsubscribe(from beacons: [Beacon]) {
        objc_sync_enter(observedBeacons)
        beacons.forEach { (aBeacon) in
            guard let token = observedBeacons[aBeacon] else { return }
            aBeacon.announcer.removeObserver(token)
            observedBeacons.removeValue(forKey: aBeacon)
        }
        objc_sync_exit(observedBeacons)
    }
    
    private func unsubscribeFromAllBeacons() {
        objc_sync_enter(observedBeacons)
        observedBeacons.forEach { (aBeacon, token) in
            aBeacon.announcer.removeObserver(token)
        }
        observedBeacons.removeAll()
        objc_sync_exit(observedBeacons)
    }
    
    // MARK:- CustomStringConvertible
    
    public override var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
}
