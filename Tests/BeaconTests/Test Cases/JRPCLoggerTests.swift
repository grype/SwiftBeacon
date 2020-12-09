//
//  JRPCLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import XCTest
@testable import Beacon

class JRPCLoggerTests : XCTestCase {
    static private var QueueName = "JRPCLoggerTests"
    var interval: TimeInterval = 1
    var logger: JRPCLoggerSpy!
    var url = URL(string: "https://example.com/emit")!
    var queue = DispatchQueue(label: JRPCLoggerTests.QueueName,
                              qos: .default,
                              attributes: DispatchQueue.Attributes(),
                              autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                              target: nil)
    
    override func setUp() {
        super.setUp()
        logger = JRPCLoggerSpy(url: url, method: "emit", name: JRPCLoggerTests.QueueName, interval: interval, queue: queue)
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
        logger = nil
    }
    
    // MARK: - Test Cases
    
    func testInit() {
        XCTAssertEqual(logger.name, String(describing: type(of: self)), "Logger isn't named by init param")
        XCTAssertEqual(logger.queue, queue, "Logger didn't init with correct queue")
        XCTAssertFalse(logger.isRunning, "Logger is starting after init")
        XCTAssertEqual(logger.url, url, "Logger has incorrect url after init")
        XCTAssertFalse(logger.flushTimer?.isValid ?? false, "Flush timer shouldn't be running after init")
        XCTAssertNil(logger.urlSessionTask, "URLSessionTask should be nil after init")
        XCTAssertNil(logger.lastCompletionDate, "LastCompletionDate should be nil after init")
    }
    
    func testStart() {
        logger.start()
        XCTAssertTrue(logger.isRunning, "Logger should be running after start()")
        XCTAssertTrue(logger.flushTimer?.isValid ?? false, "Flush timer should be valid after start()")
        XCTAssertNil(logger.urlSessionTask, "URLSessionTask should be nil after init")
        XCTAssertNil(logger.lastCompletionDate, "LastCompletionDate should be nil after init")
    }
    
    func testStop() {
        logger.start()
        logger.stop()
        XCTAssertFalse(logger.isRunning, "Logger should be running after start()")
        XCTAssertFalse(logger.flushTimer?.isValid ?? false, "Flush timer should be valid after start()")
        XCTAssertNil(logger.urlSessionTask, "URLSessionTask should be nil after init")
        XCTAssertNil(logger.lastCompletionDate, "LastCompletionDate should be nil after init")
    }
    
    func testNextPut() {
        logger.start()
        logger.nextPut(StringSignal("Hello world"))
        
        let expectBuffer = expectation(description: "Buffering")
        logger.queue.async {
            expectBuffer.fulfill()
        }
        wait(for: [expectBuffer], timeout: 1)
        XCTAssertEqual(logger.buffer.count, 1, "Expected a single signal in the buffer")
    }
    
    func testNextPutWithUserInfo() {
        logger.start()
        let signal = StringSignal("Hello world")
        signal.userInfo = ["Number" : 123, "String" : "Hello", "Bool" : true]
        logger.nextPut(signal)
        let expectBuffer = expectation(description: "Buffering")
        logger.queue.async {
            expectBuffer.fulfill()
        }
        wait(for: [expectBuffer], timeout: 1)
        logger.flush()
        let list = logger.invokedPerformParametersList
        let httpBody = String(data: list.first!.0.httpBody!, encoding: .utf8)
        let encodedSignal = String(data: try! JSONEncoder().encode(signal), encoding: .utf8)!
        XCTAssert(httpBody!.contains(encodedSignal))
    }
    
    func testFlush() {
        logger.start()
        
        XCTAssertEqual(logger.invokedFlushCount, 0, "Should have invoked flush only once")
        XCTAssertEqual(logger.invokedCreateUrlRequestCount, 0, "Should have created URL Request only once")
        XCTAssertEqual(logger.invokedPerformCount, 0, "Should have performed URL Request only oince after flush")
        
        logger.nextPut(StringSignal("Hello world"))
        
        let expectFlush = expectation(description: "Flushing")
        logger.queue.asyncAfter(deadline: .now() + logger.flushInterval + 0.1) {
            expectFlush.fulfill()
        }
        wait(for: [expectFlush], timeout: logger.flushInterval + 0.2)
        
        XCTAssertEqual(logger.invokedFlushCount, 1, "Should have invoked flush only once")
        XCTAssertEqual(logger.invokedCreateUrlRequestCount, 1, "Should have created URL Request only once")
        XCTAssertEqual(logger.invokedPerformCount, 1, "Should have performed URL Request only oince after flush")
    }
    
    func testLoggingSringError() {
        logger.start()
        
        logger.nextPut(ErrorSignal(error: "Test error" as Error))
        let expectFlush = expectation(description: "Flushing")
        logger.queue.asyncAfter(deadline: .now() + logger.flushInterval + 0.1) {
            expectFlush.fulfill()
        }
        wait(for: [expectFlush], timeout: logger.flushInterval + 0.2)
        
        XCTAssertEqual(logger.invokedFlushCount, 1, "Should have invoked flush only once")
        XCTAssertEqual(logger.invokedCreateUrlRequestCount, 1, "Should have created URL Request only once")
        XCTAssertEqual(logger.invokedPerformCount, 1, "Should have performed URL Request only oince after flush")
    }
    
}
