//
//  BeaconTest.swift
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest

class BeaconTest: XCTestCase {
    private var beacon: Beacon!
    private var logger: BeaconMemoryLogger!
    
    override func setUp() {
        beacon = Beacon()
        logger = BeaconMemoryLogger.starting(name: "Test Logger", beacon: beacon)
    }
    
    override func tearDown() {
        logger.stop()
        beacon.loggers.removeAll()
        logger = nil
        beacon = nil
    }
    
    func testSignaling() {
        beacon.signal(ContextSignal())
        assert(logger.recordings.count == 1, "Registered logger did not receive signal")
    }
    
    func testSignalingWhileStopped() {
        logger.stop()
        beacon.signal(ContextSignal())
        assert(logger.recordings.count == 0, "Registered logger did receive signal despite being stopped")
    }
    
    func testSignalingWhileFiltering() {
        logger.stop()
        logger.start { (aSignal) -> Bool in
            return aSignal is ContextSignal
        }
        beacon.signal(WrapperSignal("Wrapped signal should be ignored"))
        assert(logger.recordings.count == 0, "WrapperSignal instances should be getting ignored")
        beacon.signal(ContextSignal())
        assert(logger.recordings.count == 1, "ContextSignal instances should pass through")
    }
    
}
