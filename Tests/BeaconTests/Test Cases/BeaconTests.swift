//
//  BeaconTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
import Combine
@testable import Beacon

class BeaconTest: XCTestCase {
    private var beacon: PassthroughSubject<Signal,Never>!
    private var logger: MemoryLogger!
    private var bag: [AnyCancellable]!
    
    override func setUp() {
        bag = []
        beacon = .init()
        logger = MemoryLogger(name: "Test Logger")
    }
    
    override func tearDown() {
        logger.cancel()
        logger = nil
        beacon = nil
    }
    
    func testSignaling() {
        beacon.subscribe(logger)
        beacon.send(ContextSignal())
        expect(self.logger.recordings.count) == 1
    }
    
    func testSignalingWhileStopped() {
        logger.cancel()
        beacon.send(ContextSignal())
        expect(self.logger.recordings.count) == 0
    }
    
    func testSignalingWhileFiltering() {
        beacon.filter { $0 is ContextSignal }.subscribe(logger)
        beacon.send(WrapperSignal("Wrapped signal should be ignored"))
        expect(self.logger.recordings.count) == 0
        beacon.send(ContextSignal())
        expect(self.logger.recordings.count) == 1
    }
    
    func testPerformance() {
        let beacon = PassthroughSubject<Signal,Never>()
        let logger = MemoryLogger(name: "Memory Test Logger")
        beacon.subscribe(logger)
        measure {
            for _ in 1..<10000 {
                beacon.send(Signal())
            }
        }
        
    }

}
