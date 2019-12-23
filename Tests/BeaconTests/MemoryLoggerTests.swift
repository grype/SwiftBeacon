//
//  MemoryLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/26/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Beacon

class MemoryLoggerTests: XCTestCase {
    private var logger: MemoryLogger!
    
    static var allTests = [
        ("testNextPut", testNextPut),
        ("testClear", testClear),
        ("testLimit", testLimit),
    ]
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "Test logger")
    }
    
    func testNextPut() {
        logger.nextPut(ContextSignal())
        assert(logger.recordings.count == 1, "Logger should have recorded a signal")
    }
    
    func testClear() {
        logger.nextPut(ContextSignal())
        logger.clear()
        assert(logger.recordings.count == 0, "Logged recordings should have been cleared")
    }
    
    func testLimit() {
        logger.limit = 2
        let signals = (first: WrapperSignal(1), second: WrapperSignal(2), third: WrapperSignal(3))
        logger.nextPut(signals.first)
        logger.nextPut(signals.second)
        logger.nextPut(signals.third)
        assert(logger.recordings.count == 2, "Logger should keep at most the configured limit of recordings")
        assert(logger.recordings.contains(signals.second), "Logger did not keep second to last recording")
        assert(logger.recordings.contains(signals.third), "Logger did not keep last recording")
    }
}
