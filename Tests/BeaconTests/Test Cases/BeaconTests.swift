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
        logger = MemoryLogger(name: "Test Logger")
        logger.beForTesting()
        logger.start(on: [beacon])
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
    
    func testPerformance() {
        let beacon = Beacon()
        let logger = MemoryLogger(name: "Memory Test Logger")
        logger.beForTesting()
        logger.start(on: [beacon], filter: nil)
        measure {
            for _ in 1..<10000 {
                Signal().emit(on: [beacon])
            }
        }
        logger.stop()
    }

}
