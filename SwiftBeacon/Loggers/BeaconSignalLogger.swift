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

class BeaconSignalLogger {
    var beacon: Beacon
    var name: String
    private var isRunning = false
    typealias Filter = (BeaconSignal)->Bool
    
    init(name aName: String, beacon aBeacon: Beacon? = nil) {
        name = aName
        beacon = aBeacon ?? Beacon.shared
    }
    
    // MARK:- Starting/Stopping
    
    func start(filter: Filter? = nil) {
        guard !isRunning else { return }
        beacon.announcer.addObserver(forName: NSNotification.Name.BeaconSignal,
                                     object: nil,
                                     queue: nil) { [weak self] (aNotification) in
                                        guard let userInfo = aNotification.userInfo as? [String: BeaconSignal],
                                            let signal = userInfo["signal"] else { return }
                                        if let filter = filter, !filter(signal) {
                                            return
                                        }
                                        self?.nextPut(signal)
        }
        isRunning = true
    }
    
    func stop() {
        guard isRunning else { return }
        unsubscribe()
        isRunning = false
    }
    
    private func unsubscribe() {
        beacon.announcer.removeObserver(self)
    }
    
    // MARK:- Signaling
    
    func nextPut(_ aSignal: BeaconSignal) {
        fatalError("Subclass must override \(#function)")
    }
    
    func nextPutAll(_ signals: [BeaconSignal]) {
        signals.forEach { (aSignal) in
            nextPut(aSignal)
        }
    }
    
}

extension BeaconSignalLogger : CustomStringConvertible {
    var description: String {
        return "<\(String(describing: type(of: self))): \(Unmanaged.passUnretained(self).toOpaque())> Name: \(name); Running: \(isRunning)"
    }
}
