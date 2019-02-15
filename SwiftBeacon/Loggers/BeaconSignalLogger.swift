//
//  BeaconSignalLogger.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

fileprivate func isTypeOf<T>(_ instance: Any, a kind: T.Type) -> Bool{
    return instance is T;
}

public class BeaconSignalLogger : CustomStringConvertible {
    public let beacon: Beacon
    public let name: String
    
    private var isRunning = false
    
    public typealias Filter = (BeaconSignal)->Bool
    private var filter: Filter?
    
    public static func starting(name aName: String, beacon aBeacon: Beacon? = nil, filter: Filter? = nil) -> Self {
        let instance = self.init(name: aName, beacon: aBeacon)
        instance.start(filter: filter)
        return instance
    }
    
    public required init(name aName: String, beacon aBeacon: Beacon? = nil) {
        name = aName
        beacon = aBeacon ?? Beacon.shared
    }
    
    // MARK:- Starting/Stopping
    
    public func start(filter aFilter: Filter? = nil) {
        filter = aFilter
        guard !isRunning else { return }
        subscribe()
        isRunning = true
    }
    
    public func stop() {
        guard isRunning else { return }
        unsubscribe()
        isRunning = false
    }
    
    // MARK:- Signaling
    
    public func nextPut(_ aSignal: BeaconSignal) {
        fatalError("Subclass must override \(#function)")
    }
    
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
    
    // MARK:- CustomStringConvertible
    
    public var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
}
