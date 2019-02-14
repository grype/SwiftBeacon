//
//  BeaconMemoryLogger.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class BeaconMemoryLogger : BeaconSignalLogger {
    static var shared = BeaconMemoryLogger(name: "BeaconMemoryLogger")
    
    private(set) var recordings = [BeaconSignal]()
    var limit: Int = 100
    
    override func nextPut(_ aSignal: BeaconSignal) {
        objc_sync_enter(recordings)
        defer { objc_sync_exit(recordings) }
        
        recordings.append(aSignal)
        guard limit > 0, recordings.count > limit, recordings.count - limit > 0 else { return }
        recordings.removeFirst(recordings.count - limit)
    }
    
    func clear() {
        objc_sync_enter(recordings)
        recordings.removeAll()
        objc_sync_exit(recordings)
    }
}
