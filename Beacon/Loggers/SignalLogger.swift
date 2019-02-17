//
//  SignalLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

fileprivate func isTypeOf<T>(_ instance: Any, a kind: T.Type) -> Bool{
    return instance is T;
}

/**
 I am an abstract logger of `BeaconSignal`s.
 
 There exist a few concrete subclasses of me, like `ConsoleLogger` and `MemoryLogger`.
 
 I carry a `name` to disinguish myself from other loggers. I also keep a reference to the `Beacon`
 on which I observe signals, defaulting to `Beacon.shared` instance.
 
 # Subclassing notes
 
 - At the bare minumum, override `nextPut(_:)`. In that method, take care of handling the signal.
 - Override `nextPutAll(_:)` if special care is needed when handling multiple signals.
 - Override `description` for customizing my description.
 
 - See Also: `ConsoleLogger`, `MemoryLogger`
 */
public class SignalLogger : CustomStringConvertible, Hashable {
    
    /// Beacon instance.
    /// When the logger is started, it subscribes to notifications posted to this Beacon's announcer.
    public var beacon: Beacon {
        willSet {
            if isRunning { stop() }
        }
    }
    
    /// Logger name.
    /// Used to distinguish one logger from another.
    public var name: String
    
    /// Indicates whether the logger is running.
    /// When running, it will respond to signals posted to its beacon's announcer.
    private(set) var isRunning = false
    
    /// Filtering function takes a signal as an argument and return a boolean value
    /// indicating whether the signal should be processed
    public typealias Filter = (BeaconSignal)->Bool
    
    /// Filter function.
    /// When specified, the logger will process only those signals to which this function answers truthfully.
    private var filter: Filter?
    
    public required init(name aName: String, beacon aBeacon: Beacon = Beacon.shared) {
        name = aName
        beacon = aBeacon
    }
    
    // MARK:- Starting/Stopping
    
    /// Starts logging.
    /// This causes the logger to subscribe to signals posted by the beacon.
    public func start(filter aFilter: Filter? = nil) {
        filter = aFilter
        guard !isRunning else { return }
        subscribe()
        isRunning = true
    }
    
    /// Stops logging.
    public func stop() {
        guard isRunning else { return }
        unsubscribe()
        isRunning = false
    }
    
    // MARK:- Signaling
    
    /// Processes a signal.
    public func nextPut(_ aSignal: BeaconSignal) {
        fatalError("Subclass must override \(#function)")
    }
    
    /// Process signals in bulk.
    public func nextPutAll(_ signals: [BeaconSignal]) {
        signals.forEach { (aSignal) in
            nextPut(aSignal)
        }
    }
    
    // MARK:- Processing signals
    
    private func shouldProcess(_ signal: BeaconSignal) -> Bool {
        guard isRunning else { return false }
        guard let filter = filter else {
            return true
        }
        return filter(signal)
    }
    
    private func process(_ signal: BeaconSignal) {
        nextPut(signal)
    }
    
    @objc private func didReceiveSignalNotification(_ aNotification: Notification) {
        guard
            let signal = aNotification.beaconSignal,
            shouldProcess(signal)
            else { return }
        process(signal)
    }
    
    // MARK:- Un/Subscribing
    
    private func subscribe() {
        beacon.announcer.addObserver(self,
                                     selector: #selector(didReceiveSignalNotification(_:)),
                                     name: .BeaconSignal,
                                     object: beacon)
    }
    
    private func unsubscribe() {
        beacon.announcer.removeObserver(self)
    }
    
    // MARK:- Hashable
    
    public static func == (lhs: SignalLogger, rhs: SignalLogger) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    // MARK:- CustomStringConvertible
    
    public var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
}
