//
//  StreamLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon

class StreamLoggerTests : XCTestCase {
    
    private var logger: StreamLoggerSpy!
    
    private let stringEncoder = SignalStringEncoder(.utf8)
    
    private var stream: OutputStream!
    
    override func setUp() {
        super.setUp()
        stream = OutputStream.toMemory()
        logger = StreamLoggerSpy(name: "Beacon-Test-File-Logger", on: stream, encoder: stringEncoder)
    }
    
    override func tearDown() {
        super.tearDown()
        stream.close()
        stream = nil
        logger.stop()
        logger = nil
    }
    
    func testNextPut() {
        logger.start()
        let signal = StringSignal("Hello world")
        logger.nextPut(signal)
        let result = streamContents()
        XCTAssertNotNil(result, "Failed to fetch data from log file")
        if let result = result {
            XCTAssertEqual(result, "\(signal.description)\(stringEncoder.separator)", "Logged signal isn't the same as its description")
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
        wait(for: expectations, timeout: 3, enforceOrder: false)
        
        let result = streamContents()
        XCTAssertNotNil(result, "Failed to fetch data from log file")
        if let result = result {
            let gotSorted = result.components(separatedBy: stringEncoder.separator).filter { !$0.isEmpty }.sorted()
            let expectSorted = signals.map { String(describing: $0) }.sorted()
            XCTAssertEqual(gotSorted.count, signals.count, "Inconsistent number of entries logged")
            XCTAssertEqual(gotSorted, expectSorted, "Logged signal isn't the same as its description")
        }
    }
    
    // MARK: - Helpers
    
    private func streamContents() -> String? {
        guard let data = stream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
}
