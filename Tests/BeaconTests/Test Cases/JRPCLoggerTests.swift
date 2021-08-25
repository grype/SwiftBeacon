//
//  JRPCLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon
import AnyCodable

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
        logger.beForTesting()
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
    
    func testNextPutStringWithUserInfo() {
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
        let httpJson = try! JSONSerialization.jsonObject(with: list.first!.0.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String:Any]]]).first!.first!["properties"] as! [AnyHashable : AnyHashable]
        XCTAssertEqual(httpProperties, signal.userInfo as! [AnyHashable : AnyHashable])
    }
    
    func testNextPutWrapperWithUserInfo() {
        logger.start()
        let obj = SampleObject()
        let date = Date()
        let signal = WrapperSignal(obj, userInfo: ["Number" : 123, "String" : "Hello", "Bool" : true, "Date" : date])
        logger.nextPut(signal)
        let expectBuffer = expectation(description: "Buffering")
        logger.queue.async {
            expectBuffer.fulfill()
        }
        wait(for: [expectBuffer], timeout: 1)
        logger.flush()
        
        let list = logger.invokedPerformParametersList
        let httpJson = try! JSONSerialization.jsonObject(with: list.first!.0.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String:Any]]]).first!.first!["properties"] as! [AnyHashable : AnyHashable]
        let jsonEncoder = (logger.encoder as! JSONEncoder)
        let signalJson = try! jsonEncoder.encode(AnyEncodable(signal.userInfo))
        let signalProperties = try! JSONSerialization.jsonObject(with: signalJson, options: .fragmentsAllowed) as! [AnyHashable : AnyHashable]
        XCTAssertEqual(httpProperties, signalProperties)
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
