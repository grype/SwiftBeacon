//
//  MemoryLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/26/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class MemoryLoggerTests: XCTestCase {
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "Test logger")
    }
    
    func testNextPut() {
        logger.nextPut(ContextSignal())
        expect(self.logger.recordings.count).to(equal(1))
    }
    
    func testClear() {
        logger.nextPut(ContextSignal())
        logger.clear()
        expect(self.logger.recordings.count).to(equal(0))
    }
    
    func testLimit() {
        let logger = self.logger!
        logger.limit = 2
        let signals = (first: WrapperSignal(1), second: WrapperSignal(2), third: WrapperSignal(3))
        logger.nextPut(signals.first)
        logger.nextPut(signals.second)
        logger.nextPut(signals.third)
        expect(logger.recordings.count).to(equal(2))
        expect(logger.recordings.contains(signals.second)).to(beTrue())
        expect(logger.recordings.contains(signals.third)).to(beTrue())
    }
}
