//
//  BeaconTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Beacon

class BeaconTest: XCTestCase {
    private var beacon: Beacon!
    private var logger: MemoryLogger!
    
    override func setUp() {
        beacon = Beacon()
        logger = MemoryLogger.starting(name: "Test Logger", on: [beacon])
    }
    
    override func tearDown() {
        logger.stop()
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
        logger.start(on: [beacon]) { (aSignal) -> Bool in
            return aSignal is ContextSignal
        }
        beacon.signal(WrapperSignal("Wrapped signal should be ignored"))
        assert(logger.recordings.count == 0, "WrapperSignal instances should be getting ignored")
        beacon.signal(ContextSignal())
        assert(logger.recordings.count == 1, "ContextSignal instances should pass through")
    }
    
    func testAggregationOfSingles() {
        let result = beacon + Beacon.shared
        assert(result == [beacon, Beacon.shared], "Adding two beacons should aggregate them into an array")
    }
    
    func testAggregationOfArraysOfBeacons() {
        let first = [Beacon(), Beacon()]
        let second = [Beacon(), Beacon()]
        let result = first + second
        assert(result == [first[0], first[1], second[0], second[1]], "Adding two arrays of beacons should result in a flat array containing their elements")
    }
    
    func testMixedAggregation() {
        let first = Beacon()
        let second = [Beacon(), Beacon()]
        let result = first + second
        assert(result == [first, second[0], second[1]], "Adding beacon and array of beacons should result in a flat array containing all of them")
    }

}
