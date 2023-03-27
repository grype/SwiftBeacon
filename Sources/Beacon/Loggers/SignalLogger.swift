//
//  SignalLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import RWLock
import SwiftAnnouncements

/**
 I am an abstract logger of `Signal`s.
 
 There exist a few concrete subclasses of me, like `ConsoleLogger` and `MemoryLogger`.
 
 I carry a `name` to disinguish myself from other loggers. I also keep a reference to the `Beacon`
 on which I observe signals, defaulting to `Beacon.shared` instance.
 
 **Subclassing notes**
 
 - At the bare minumum, override `nextPut(_:)`. In that method, take care of handling the signal.
 - Override `nextPutAll(_:)` if special care is needed when handling multiple signals.
 - Override `description` for customizing my description.
 
 **Identifying a client**
 
 It may be beneficial to identify the client whenever the logger starts. Especially when utilizing a logger in production, on remote machines. There exists a special `IdentifySignal` that captures particulars about the machine. I can be configured to emit that signal when it is started via `identifiesOnStart`.
 
 **Tracking framework loading**
 
 It may be beneficial to track when MachO images are being loaded - this happens whenever a framework gets loaded. Doing so will help with symbolication of stack traces, when working with binaries with stripped symbols. Crashlogs automatically capture this information, but emitting an error or context signals, doesn't really provide all the particulars needed to symbolicate the stack trace.
 
 For that reason, I can be configured to track image un-/loading via the `tracksMachImageImports` property. When true, I will emit `MachOImageImportsSignal` whenever an image is loaded or unloaded, and I will also emit a signal with all of the already loaded images whenever I am started.
 
 - See Also: `ConsoleLogger`, `MemoryLogger`
 */
open class SignalLogger: NSObject {
    // MARK: - Type aliases
    
    /// Filtering function takes a signal as an argument and return a boolean value
    /// indicating whether the signal should be processed
    public typealias Filter = (Signal) -> Bool
    
    /// Block of code for evaluating during momentary runs
    ///
    /// - See: `run(during:)`
    public typealias RunBlock = (SignalLogger) -> Void
    
    // MARK: - Properties
    
    /// Logger name.
    /// Used to distinguish one logger from another.
    @objc open var name: String
    
    /// Indicates whether the logger is running.
    /// When running, it will respond to signals posted to its beacon's announcer.
    @objc open var isRunning: Bool {
        return !observedBeacons.isEmpty
    }
    
    @objc open var identifiesOnStart = false
    
    @objc open var tracksMachImageImports = false
    
    /// Array of all observed beacons
    @RWLocked private var observedBeacons = [Beacon]()
    
    /// Creates a running instance
    open class func starting<T: SignalLogger>(name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
        let me = self.init(name: aName)
        me.start(on: beacons, filter: filter)
        return me as! T
    }
    
    // MARK: - Initialization
    
    @objc public required init(name aName: String) {
        name = aName
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Starting/Stopping
    
    /// Starts observing shared beacon object and logging relevant signals.
    /// If filter function is given, only those signals for which the function returns true will be handled.
    @objc open func start(filter aFilter: Filter? = nil) {
        start(on: [Beacon.shared], filter: aFilter)
    }
    
    /// Starts observing given beacons and logging relevant signals.
    /// If filter function is given, only those signals for which the function returns true will be handled.
    @objc open func start(on beacons: [Beacon] = [Beacon.shared], filter aFilter: Filter? = nil) {
        subscribe(to: beacons, filter: aFilter)
    }
    
    /// Start on shared beacon for the duration of the given run block
    @objc open func run(during: RunBlock) {
        run(on: [Beacon.shared], during: during)
    }
    
    /// Start on given beacons for the duration of the given run block
    @objc open func run(on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        subscribe(to: beacons)
        runBlock(self)
        unsubscribe(from: beacons)
    }
    
    /// Start on given beacons for the duration of the given run block, filtering in given signal types
    @objc open func run(for signals: [Signal.Type], on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        subscribe(to: beacons) { aSignal -> Bool in
            signals.first(where: { aType -> Bool in
                aType == type(of: aSignal)
            }) != nil
        }
        runBlock(self)
        unsubscribe(from: beacons)
    }
    
    /// Stops observing given beacons and with that logging any signals emitted on those beacons.
    @objc open func stop(on beacons: [Beacon] = [Beacon.shared]) {
        beacons.forEach { aBeacon in
            unsubscribe(from: aBeacon)
        }
    }
    
    /// Stops observing all currently observing beacons. No logging will take place until started again.
    @objc open func stop() {
        unsubscribeFromAllBeacons()
    }
    
    @objc internal func didStart(on beacons: [Beacon]) {
        if tracksMachImageImports {
            startTrackingMachImageImports()
        }
        if identifiesOnStart {
            identify(on: beacons)
        }
    }
    
    @objc internal func didStop() {
        MachImageMonitor.shared.announcer.unsubscribe(self)
    }
    
    // MARK: - Signaling
    
    /// Processes a signal.
    @objc open func nextPut(_ aSignal: Signal) {
        fatalError("Subclass must override \(#function)")
    }
    
    /// Process signals in bulk.
    @objc open func nextPutAll(_ signals: [Signal]) {
        signals.forEach { aSignal in
            nextPut(aSignal)
        }
    }
    
    // MARK: - Processing signals
    
    private func process(_ signal: Signal) {
        nextPut(signal)
    }
    
    // MARK: - Subscribing
    
    internal func subscribe(to aBeacon: Beacon, filter: Filter? = nil) {
        subscribe(to: [aBeacon], filter: filter)
    }
    
    internal func subscribe(to beacons: [Beacon], filter: Filter? = nil) {
        beacons.forEach { aBeacon in
            aBeacon.unsubscribe(self)
            aBeacon.when(Signal.self, subscriber: self) { [weak self] aSignal, _ in
                guard let self = self else { return }
                
                guard filter?(aSignal) ?? true else { return }
                self.process(aSignal)
            }
        }
        observedBeacons = beacons
        didStart(on: beacons)
    }
    
    internal func unsubscribe(from aBeacon: Beacon) {
        unsubscribe(from: [aBeacon])
    }
    
    internal func unsubscribe(from beacons: [Beacon]) {
        beacons.forEach { aBeacon in
            aBeacon.unsubscribe(self)
            observedBeacons.removeAll { each -> Bool in
                each === aBeacon
            }
        }
        guard observedBeacons.isEmpty else { return }
        didStop()
    }
    
    internal func unsubscribeFromAllBeacons() {
        observedBeacons.forEach { aBeacon in
            aBeacon.unsubscribe(self)
        }
        observedBeacons.removeAll()
        didStop()
    }
    
    // MARK: - CustomStringConvertible
    
    override open var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
    
    // MARK: - Identifying
    
    open func identify(on beacons: [Beacon] = [.shared]) {
        nextPut(IdentitySignal().sourcedFromHere())
    }
    
    // MARK: - MachO
    
    private func startTrackingMachImageImports() {
        // Start monitoring if we haven't yet. This will subscribe to updates using a callback,
        // which will then be fired for each image already loaded.
        // Note that since no logger has had a chance to start observing announcements, these callbacks
        // won't amount to any signals being emitted. This is why we do this first and then, immediately after,
        // start observing for announcements.
        // This will always emit at least one signal with all of the loaded images.
        if !MachImageMonitor.isRunning {
            MachImageMonitor.startMonitoring()
        }
        
        MachImageMonitor.shared.announcer.when(MachImageMonitor.Announcement.self, subscriber: self) { [weak self] announcement, _ in
            guard let signal = self?.createSignal(for: announcement) else { return }
            self?.nextPut(signal.sourcedFromHere())
        }
        
        // Explicitly capture and log list of known images as being added
        let signal = MachImageImportsSignal()
        signal.added = MachImageMonitor.shared.images
        nextPut(signal.sourcedFromHere())
    }
    
    private func createSignal(for announcement: MachImageMonitor.Announcement) -> MachImageImportsSignal {
        let signal = MachImageImportsSignal()
        if case let .didAddImage(anImage) = announcement {
            signal.added = [anImage]
        }
        else if case let .didRemoveImage(anImage) = announcement {
            signal.removed = [anImage]
        }
        return signal
    }
}
