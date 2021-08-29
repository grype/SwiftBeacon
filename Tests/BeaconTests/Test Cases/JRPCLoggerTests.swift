//
//  JRPCLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import AnyCodable
import Cuckoo
import Nimble
@testable import Beacon

class JRPCLoggerTests : XCTestCase {
    
    static private var QueueName = "JRPCLoggerTests"
    
    var interval: TimeInterval = 1
    
    var logger: MockJRPCLogger!
    
    var url = URL(string: "https://example.com/emit")!
    
    var queue = DispatchQueue(label: JRPCLoggerTests.QueueName,
                              qos: .default,
                              attributes: DispatchQueue.Attributes(),
                              autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                              target: nil)
    
    // MARK:- Setup/Teardown
    
    override func setUp() {
        super.setUp()
        logger = MockJRPCLogger(url: url, method: "emit", name: JRPCLoggerTests.QueueName, interval: interval, queue: queue).withEnabledSuperclassSpy()
        logger.beForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
        logger = nil
    }
    
    // MARK: - Tests
    
    func testInit() {
        let logger = self.logger!
        expect(logger.name).to(equal(String(describing: type(of: self))))
        expect(logger.queue).to(equal(queue))
        expect(logger.isRunning).to(beFalse())
        expect(logger.url).to(equal(url))
        expect(logger.flushTimer?.isValid ?? false).to(beFalse())
        expect(logger.urlSessionTask).to(beNil())
        expect(logger.lastCompletionDate).to(beNil())
    }
    
    func testStart() {
        let logger = self.logger!
        logger.start()
        expect(logger.isRunning).to(beTrue())
        expect(logger.flushTimer?.isValid ?? false).to(beTrue())
        expect(logger.urlSessionTask).to(beNil())
        expect(logger.lastCompletionDate).to(beNil())
    }
    
    func testStop() {
        let logger = self.logger!
        logger.start()
        logger.stop()
        expect(logger.isRunning).to(beFalse())
        expect(logger.flushTimer?.isValid ?? false).to(beFalse())
        expect(logger.urlSessionTask).to(beNil())
        expect(logger.lastCompletionDate).to(beNil())
    }
    
    func testNextPut() {
        let logger = self.logger!
        logger.start()
        logger.nextPut(StringSignal("Hello world"))
        expect(logger.buffer.count).toEventually(equal(1))
    }
    
    func testNextPutStringWithUserInfo() {
        let logger = self.logger!
        logger.start()
        let signal = StringSignal("Hello world")
        signal.userInfo = ["Number" : 123, "String" : "Hello", "Bool" : true]
        logger.nextPut(signal)
        
        waitUntil { done in
            logger.queue.async {
                done()
            }
        }
        logger.flush()
        
        let argumentCaptor = ArgumentCaptor<URLRequest>()
        verify(logger).perform(urlRequest: argumentCaptor.capture(), completion: any())
        let httpJson = try! JSONSerialization.jsonObject(with: argumentCaptor.value!.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String:Any]]]).first!.first!["properties"] as! [AnyHashable : AnyHashable]
        expect(httpProperties).to(equal((signal.userInfo as! [AnyHashable : AnyHashable])))
    }
    
    func testNextPutWrapperWithUserInfo() {
        let logger = self.logger!
        logger.start()
        let obj = SampleObject()
        let date = Date()
        let signal = WrapperSignal(obj, userInfo: ["Number" : 123, "String" : "Hello", "Bool" : true, "Date" : date])
        logger.nextPut(signal)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(Int(logger.flushInterval + 0.1))) { done in
            logger.queue.async {
                logger.flush()
                done()
            }
        }
        
        let argumentCaptor = ArgumentCaptor<URLRequest>()
        verify(logger).perform(urlRequest: argumentCaptor.capture(), completion: any())
        let httpJson = try! JSONSerialization.jsonObject(with: argumentCaptor.value!.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String:Any]]]).first!.first!["properties"] as! [AnyHashable : AnyHashable]
        let jsonEncoder = (logger.encoder as! JSONSignalEncoder)
        let signalJson = try! jsonEncoder.encoder.encode(AnyEncodable(signal.userInfo))
        let signalProperties = try! JSONSerialization.jsonObject(with: signalJson, options: .fragmentsAllowed) as! [AnyHashable : AnyHashable]
        expect(httpProperties).to(equal(signalProperties))
    }
    
    func testFlush() {
        let logger = self.logger!
        logger.start()
        
        verify(logger, times(0)).flush()
        verify(logger, times(0)).createUrlRequest(with: any())
        verify(logger, times(0)).perform(urlRequest: any(), completion: any())
        
        logger.nextPut(StringSignal("Hello world"))
        
        waitUntil(timeout: .seconds(Int(logger.flushInterval + 1))) { done in
            logger.queue.asyncAfter(deadline: .now() + logger.flushInterval + 0.1) {
                done()
            }
        }
        
        verify(logger, times(1)).flush()
        verify(logger, times(1)).createUrlRequest(with: any())
        verify(logger, times(1)).perform(urlRequest: any(), completion: any())
    }
    
    func testLoggingSringError() {
        let logger = self.logger!
        logger.start()
        
        logger.nextPut(ErrorSignal(error: "Test error" as Error))
        waitUntil(timeout: .seconds(Int(logger.flushInterval + 1))) { done in
            logger.queue.asyncAfter(deadline: .now() + logger.flushInterval + 0.1) {
                done()
            }
        }
        
        verify(logger, times(1)).flush()
        verify(logger, times(1)).createUrlRequest(with: any())
        verify(logger, times(1)).perform(urlRequest: any(), completion: any())
    }
    
}
