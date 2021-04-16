//
//  BeaconTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

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
        expect(self.logger.recordings.count) == 1
    }
    
    func testSignalingWhileStopped() {
        logger.stop()
        beacon.signal(ContextSignal())
        expect(self.logger.recordings.count) == 0
    }
    
    func testSignalingWhileFiltering() {
        logger.stop()
        logger.start(on: [beacon]) { (aSignal) -> Bool in
            return aSignal is ContextSignal
        }
        beacon.signal(WrapperSignal("Wrapped signal should be ignored"))
        expect(self.logger.recordings.count) == 0
        beacon.signal(ContextSignal())
        expect(self.logger.recordings.count) == 1
    }
    
    func testAggregationOfSingles() {
        let result = beacon + Beacon.shared
        expect(result).to(equal([beacon, Beacon.shared]))
    }
    
    func testAggregationOfArraysOfBeacons() {
        let first = [Beacon(), Beacon()]
        let second = [Beacon(), Beacon()]
        let result = first + second
        expect(result) == [first[0], first[1], second[0], second[1]]
    }
    
    func testMixedAggregation() {
        let first = Beacon()
        let second = [Beacon(), Beacon()]
        let result = first + second
        expect(result) == [first, second[0], second[1]]
    }

}
