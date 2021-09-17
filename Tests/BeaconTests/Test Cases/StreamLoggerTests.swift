//
//  StreamLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Cuckoo
import Nimble
@testable import Beacon

class StreamLoggerTests : XCTestCase {
    
    private var logger: MockStreamLogger!
    
    private var writer: MockEncodedStreamSignalWriter!
    
    private var encoder: SignalDescriptionEncoder { writer.encoder as! SignalDescriptionEncoder }
    
    private var stream: OutputStream { writer.stream }
    
    private var separator: String? {
        let separator = writer.separator
        return String(data: separator, encoding: encoder.encoding)
    }
    
    // MARK:- Setup/Teardown
    
    override func setUp() {
        super.setUp()
        writer = MockEncodedStreamSignalWriter(on: OutputStream.toMemory(), encoder: SignalDescriptionEncoder(encoding: .utf8)).withEnabledSuperclassSpy()
        writer.separator = "\n".data(using: encoder.encoding)!
        logger = MockStreamLogger(name: "Beacon-Test-File-Logger", writer: writer).withEnabledSuperclassSpy()
        logger.beForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        logger?.stop()
        logger = nil
    }
    
    // MARK: - Helpers
    
    private func streamContents() -> String? {
        guard let data = stream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK:- Tests
    
    func testNextPut() {
        logger.start()
        let signal = StringSignal("Hello world")
        logger.nextPut(signal)
        let result = streamContents()
        expect(result).toNot(beNil())
        if let result = result {
            expect(result).to(equal("\(signal.description)\(separator!)"))
        }
    }
    
    func testThreadSafety() {
        logger.start()
        var signals = [StringSignal]()
        var expectations = [XCTestExpectation]()
        let count = 10
        (0..<count).forEach { (i) in
            signals.append(StringSignal("Signal \(i)"))
            expectations.append(XCTestExpectation(description: "Expectation \(1)"))
        }
        let queue = DispatchQueue(label: "FileLoggerConcurrencyTest", qos: .default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        (0..<count).forEach { (i) in
            queue.async {
                self.logger.nextPut(signals[i])
                expectations[i].fulfill()
            }
        }
        wait(for: expectations, timeout: 2, enforceOrder: false)
        
        let result = streamContents()
        XCTAssertNotNil(result, "Failed to fetch data from log file")
        if let result = result {
            let gotSorted = result.components(separatedBy: separator!).filter { !$0.isEmpty }.sorted()
            let expectSorted = signals.map { String(describing: $0) }.sorted()
            XCTAssertEqual(gotSorted.count, signals.count, "Inconsistent number of entries logged")
            XCTAssertEqual(gotSorted, expectSorted, "Logged signal isn't the same as its description")
        }
    }
    
}
