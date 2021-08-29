//
//  IntervalLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/26/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Cuckoo
import Nimble
@testable import Beacon

class IntervalLoggerTests : XCTestCase {
    var logger: MockIntervalLogger!
    let interval: TimeInterval = 1
    let queue = DispatchQueue(label: "IntervalLoggerTests", qos: .default, attributes: DispatchQueue.Attributes(), autoreleaseFrequency: .inherit, target: nil)
    var signals = [Signal]()
    
    override func setUp() {
        super.setUp()
        logger = MockIntervalLogger(name: "IntervalLoggerTest", interval: 1, queue: queue).withEnabledSuperclassSpy()
        logger.beForTesting()
        stub(logger) { stub in
            when(stub.encodeSignal(any())).thenReturn(Data())
            when(stub.flush()).thenDoNothing()
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
        expect(self.queue).to(equal(logger.queue))
        expect(self.interval).to(equal(logger.flushInterval))
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testStart() {
        let logger = self.logger!
        logger.start()
        expect(logger.isRunning).to(beTrue())
        verify(logger, times(1)).startFlushTimer()
        expect(logger.flushTimer).toNot(beNil())
        expect(logger.flushTimer?.isValid ??  false).to(beTrue())
    }
    
    func testStop() {
        let logger = self.logger!
        logger.start()
        logger.stop()
        expect(logger.isRunning).to(beFalse())
        verify(logger, times(1)).stopFlushTimer()
        expect(logger.flushTimer).to(beNil())
        expect(logger.flushTimer?.isValid ?? false).to(beFalse())
    }
    
    func testNextPutWhenStopped() {
        let logger = self.logger!
        logger.nextPut(signals[0])
        expect(logger.buffer.count).toEventually(equal(1))
        
        logger.nextPut(signals[1])
        expect(logger.buffer.count).toEventually(equal(2))
    }
    
    func testNextPutWhenStarted() {
        let logger = self.logger!
        logger.start()
        
        logger.nextPut(signals[0])
        expect(logger.buffer.count).toEventually(equal(1))
        
        logger.nextPut(signals[1])
        expect(logger.buffer.count).toEventually(equal(2))
        waitUntil(timeout: DispatchTimeInterval.seconds(Int(logger.flushInterval) + 1)) { done in
            logger.queue.asyncAfter(deadline: .now()+logger.flushInterval + 0.1) {
                done()
            }
        }
        verify(logger, times(1)).flush()
    }
    
    func testShouldFlushWhenEmpty() {
        expect(self.logger.shouldFlush).to(beFalse())
    }
    
    func testShouldFlushWhenNotEmpty() {
        let logger = self.logger!
        logger.nextPut(signals[0])
        expect(logger.shouldFlush).toEventually(beTrue())
    }
    
    func testPushOverLimit() {
        let logger = self.logger!
        logger.maxBufferSize = 1
        logger.nextPut(signals[0])
        logger.nextPut(signals[1])
        expect(logger.buffer.count).toEventually(equal(1))
        expect(logger.buffer[0]).toEventually(equal(logger.encodeSignal(signals[1])))
    }

}
