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
    
    // MARK:- Type aliases
    
    /// Filtering function takes a signal as an argument and return a boolean value
    /// indicating whether the signal should be processed
    public typealias Filter = (Signal)->Bool
    
    /// Block of code for evaluating during momentary runs
    ///
    /// @See `run(during:)`
    public typealias RunBlock = (SignalLogger)->Void
    
    // MARK:- Properties
    
    /// Logger name.
    /// Used to distinguish one logger from another.
    @objc public var name: String
    
    /// Indicates whether the logger is running.
    /// When running, it will respond to signals posted to its beacon's announcer.
    @objc var isRunning : Bool {
        return !observedBeacons.isEmpty
    }
    
    /// Array of all observed beacons
    private var observedBeacons = [Beacon : NSObjectProtocol]()
    
    /// Creates a running instance
    public class func starting<T:SignalLogger>(name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
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
    
    /// Starts observing shared beacon object and logging relevant signals.
    /// If filter function is given, only those signals for which the function returns true will be handled.
    @objc public func start(filter aFilter: Filter? = nil) {
        start(on: [Beacon.shared], filter: aFilter)
    }
    
    /// Starts observing given beacons and logging relevant signals.
    /// If filter function is given, only those signals for which the function returns true will be handled.
    @objc public func start(on beacons: [Beacon] = [Beacon.shared], filter aFilter: Filter? = nil) {
        subscribe(to: beacons, filter: aFilter)
    }
    
    /// Start on shared beacon for the duration of the given run block
    @objc public func run(during: RunBlock) {
        run(on: [Beacon.shared], during: during)
    }
    
    /// Start on given beacons for the duration of the given run block
    @objc public func run(on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        subscribe(to: beacons)
        runBlock(self)
        unsubscribe(from: beacons)
    }
    
    /// Start on given beacons for the duration of the given run block, filtering in given signal types
    @objc public func run(for signals: [Signal.Type], on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        subscribe(to: beacons) { (aSignal) -> Bool in
            return signals.first(where: { (aType) -> Bool in
                return aType == type(of: aSignal)
            }) != nil
        }
        runBlock(self)
        unsubscribe(from: beacons)
    }
    
    /// Stops observing given beacons and with that logging any signals emitted on those beacons.
    @objc public func stop(on beacons: [Beacon] = [Beacon.shared]) {
        beacons.forEach { (aBeacon) in
            unsubscribe(from: aBeacon)
        }
    }
    
    /// Stops observing all currently observing beacons. No logging will take place until started again.
    @objc public func stop() {
        unsubscribeFromAllBeacons()
    }
    
    @objc internal func didStart() {
    }
    
    @objc internal func didStop() {
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
    
    internal func subscribe(to aBeacon: Beacon, filter: Filter? = nil) {
        subscribe(to: [aBeacon], filter: filter)
    }
    
    internal func subscribe(to beacons: [Beacon], filter: Filter? = nil) {
        objc_sync_enter(observedBeacons)
        defer { objc_sync_exit(observedBeacons) }
        
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
        didStart()
    }
    
    internal func unsubscribe(from aBeacon: Beacon) {
        unsubscribe(from: [aBeacon])
    }
    
    internal func unsubscribe(from beacons: [Beacon]) {
        objc_sync_enter(observedBeacons)
        defer { objc_sync_exit(observedBeacons) }
        
        beacons.forEach { (aBeacon) in
            guard let token = observedBeacons[aBeacon] else { return }
            aBeacon.announcer.removeObserver(token)
            observedBeacons.removeValue(forKey: aBeacon)
        }
        guard observedBeacons.isEmpty else { return }
        didStop()
    }
    
    internal func unsubscribeFromAllBeacons() {
        objc_sync_enter(observedBeacons)
        defer { objc_sync_exit(observedBeacons) }
        observedBeacons.forEach { (aBeacon, token) in
            aBeacon.announcer.removeObserver(token)
        }
        observedBeacons.removeAll()
        didStop()
    }
    
    // MARK:- CustomStringConvertible
    
    public override var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
}
