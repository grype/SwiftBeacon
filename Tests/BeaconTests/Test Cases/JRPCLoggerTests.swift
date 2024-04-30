//
//  JRPCLoggerTests.swift
//
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import AnyCodable
@testable import Beacon
import Combine
import Cuckoo
import Nimble
import XCTest

class JRPCLoggerTests: XCTestCase {
    private static var QueueName = "JRPCLoggerTests"
    
    var interval: TimeInterval = 1
    
    var logger: MockJRPCLogger!
    
    private var subject: PassthroughSubject<[Signal], Never>!
    
    var url = URL(string: "https://example.com/emit")!
    
    var queue = DispatchQueue(label: JRPCLoggerTests.QueueName,
                              qos: .default,
                              attributes: DispatchQueue.Attributes(),
                              autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                              target: nil)
    
    // MARK: - Setup/Teardown
    
    override func setUp() {
        super.setUp()
        logger = MockJRPCLogger(url: url, method: "emit", name: JRPCLoggerTests.QueueName).withEnabledSuperclassSpy()
        subject = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        subject.send(completion: .finished)
    }
    
    // MARK: - Tests
    
    func testInit() {
        let logger = self.logger!
        expect(logger.name).to(equal(String(describing: type(of: self))))
        expect(logger.url).to(equal(url))
    }
    
    func testNextPut() {
        let logger = self.logger!
        subject.subscribe(logger)
        subject.send([StringSignal("Hello world")])
        
        stub(logger) { stub in
            when(stub.perform(urlRequest: any())).thenDoNothing()
        }
        expect(logger.urlSessionTasks.count).toEventually(equal(1))
    }
    
    func testNextPutStringWithUserInfo() {
        let logger = self.logger!
        subject.subscribe(logger)
        
        stub(logger) { stub in
            when(stub.perform(urlRequest: any())).thenDoNothing()
        }
        
        let signal = StringSignal("Hello world")
        signal.userInfo = ["Number": 123, "String": "Hello", "Bool": true]
        subject.send([signal])
        
        let argumentCaptor = ArgumentCaptor<URLRequest>()
        verify(logger).perform(urlRequest: argumentCaptor.capture())
        let httpJson = try! JSONSerialization.jsonObject(with: argumentCaptor.value!.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String: Any]]]).first!.first!["properties"] as! [AnyHashable: AnyHashable]
        expect(httpProperties).to(equal((signal.userInfo as! [AnyHashable: AnyHashable])))
    }
    
    func testNextPutWrapperWithUserInfo() {
        let logger = self.logger!
        subject.subscribe(logger)
        
        let obj = SampleObject()
        let date = Date()
        let signal = WrapperSignal(obj, userInfo: ["Number": 123, "String": "Hello", "Bool": true, "Date": date])
        subject.send([signal])
        
        let argumentCaptor = ArgumentCaptor<URLRequest>()
        verify(logger).perform(urlRequest: argumentCaptor.capture())
        let httpJson = try! JSONSerialization.jsonObject(with: argumentCaptor.value!.httpBody!, options: .fragmentsAllowed) as! [String: Any]
        let httpProperties = (httpJson["params"] as! [[[String: Any]]]).first!.first!["properties"] as! [AnyHashable: AnyHashable]
        let jsonEncoder = (logger.encoder as! JSONSignalEncoder)
        let signalJson = try! jsonEncoder.encoder.encode(AnyEncodable(signal.userInfo))
        let signalProperties = try! JSONSerialization.jsonObject(with: signalJson, options: .fragmentsAllowed) as! [AnyHashable: AnyHashable]
        expect(httpProperties).to(equal(signalProperties))
    }
    
    func testLoggingSringError() {
        let logger = self.logger!
        subject.subscribe(logger)
        
        subject.send([ErrorSignal(error: "Test error" as Error)])
        verify(logger, times(1)).createUrlRequest(with: any())
        verify(logger, times(1)).perform(urlRequest: any())
    }
}
