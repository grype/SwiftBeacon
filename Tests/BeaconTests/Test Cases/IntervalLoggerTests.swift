//
//  IntervalLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/26/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon

class IntervalLoggerTests : XCTestCase {
    var logger: IntervalLoggerSpy!
    let interval: TimeInterval = 1
    let queue = DispatchQueue(label: "IntervalLoggerTests", qos: .default, attributes: DispatchQueue.Attributes(), autoreleaseFrequency: .inherit, target: nil)
    var signals = [Signal]()
    
    override func setUp() {
        super.setUp()
        logger = IntervalLoggerSpy(name: "IntervalLoggerTest", interval: 1, queue: queue)
        logger.beForTesting()
        logger.encodeBlock = { (aSignal) -> Data? in
            return String(describing: aSignal).data(using: .utf8)
        }
        signals.append(contentsOf: ["First", "Second", "Third", "Fourth"].map { StringSignal($0) })
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
        logger = nil
        signals.removeAll()
    }
    
    // MARK: - Tests
    
    func testInit() {
        XCTAssertEqual(queue, logger.queue, "Wrong queue created at init")
        XCTAssertEqual(interval, logger.flushInterval, "Wrong flush interval created at init")
        XCTAssertFalse(logger.isRunning, "Logger should be stopped when first created")
    }
    
    func testStart() {
        logger.start()
        XCTAssertTrue(logger.isRunning, "Logger should be running after start()")
        XCTAssertTrue(logger.invokedStartFlushTimer, "Should have invoked startFlushTimer() upon start()")
        XCTAssertNotNil(logger.flushTimer, "Flush timer shouldn't be nil after start()")
        XCTAssertTrue(logger.flushTimer?.isValid ?? false, "Flush timer should be valid after start()")
    }
    
    func testStop() {
        logger.start()
        logger.stop()
        XCTAssertFalse(logger.isRunning, "Logger should not be running after stop()")
        XCTAssertTrue(logger.invokedStopFlushTimer, "Should have invoked stopFlushTimer() upon stop()")
        XCTAssertNil(logger.flushTimer, "Flush timer should be nil after stop()")
        XCTAssertFalse(logger.flushTimer?.isValid ?? false, "Flush timer should be valid after stop()")
    }
    
    func testNextPutWhenStopped() {
        var expectQueue = expectation(description: "Waiting to queue up signals")
        logger.nextPut(signals[0])
        logger.queue.async {
            expectQueue.fulfill()
        }
        wait(for: [expectQueue], timeout: 1)
        XCTAssertEqual(logger.buffer.count, 1, "Logger should have queued up first signal when stopped")
        
        expectQueue = expectation(description: "Waiting to queue up signals")
        logger.nextPut(signals[1])
        logger.queue.async {
            expectQueue.fulfill()
        }
        wait(for: [expectQueue], timeout: 1)
        XCTAssertEqual(logger.buffer.count, 2, "Logger should have queued up additional signal when stopped")
    }
    
    func testNextPutWhenStarted() {
        logger.start()
        
        var expectQueue = expectation(description: "Waiting to queue up signals")
        logger.nextPut(signals[0])
        logger.queue.async {
            expectQueue.fulfill()
        }
        wait(for: [expectQueue], timeout: 1)
        XCTAssertEqual(logger.buffer.count, 1, "Logger should have queued up first signal when stopped")
        
        expectQueue = expectation(description: "Waiting to queue up signals")
        logger.nextPut(signals[1])
        logger.queue.async {
            expectQueue.fulfill()
        }
        wait(for: [expectQueue], timeout: 1)
        XCTAssertEqual(logger.buffer.count, 2, "Logger should have queued up additional signal when stopped")
        
        let expectFlush = expectation(description: "Waiting for flush")
        logger.queue.asyncAfter(deadline: .now() + logger.flushInterval) {
            expectFlush.fulfill()
        }
        wait(for: [expectFlush], timeout: logger.flushInterval + 0.1)
        XCTAssertTrue(logger.invokedFlush, "Should have invoked flush after flushInterval had lapsed")
        XCTAssertEqual(logger.invokedFlushCount, 1, "Should have invoked flush exactly once after single flushInterval had lapsed")
    }
    
    func testShouldFlushWhenEmpty() {
        XCTAssertFalse(logger.shouldFlush, "Shouldn't allow flushing when buffer is empty")
    }
    
    func testShouldFlushWhenNotEmpty() {
        logger.nextPut(signals[0])
        let expect = expectation(description: "Waiting to queue signal")
        logger.queue.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1)
        XCTAssertTrue(logger.shouldFlush, "Should allow flushing when buffer is empty")
    }
    
    func testPushOverLimit() {
        logger.maxBufferSize = 1
        logger.nextPut(signals[0])
        logger.nextPut(signals[1])
        let expect = expectation(description: "Waiting to queue signal")
        logger.queue.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1)
        XCTAssert(logger.buffer.count == 1, "Buffer should contain 1 signal")
        XCTAssert(logger.buffer[0] == logger.encodeSignal(signals[1]), "Buffer should contain last signal")
    }

}
