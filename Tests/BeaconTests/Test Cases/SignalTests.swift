//
//  SignalTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Beacon

class SignalTests : XCTestCase, Error {
    
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger.starting(name: "BeaconTestLogger")
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    func throwup() throws {
        throw self
    }
    
    func testEmitContextSignal() {
        emit()
        XCTAssertEqual(logger.recordings.count, 1, "Context did not signal")
        let signal = logger.recordings.first!
        XCTAssertTrue(type(of: signal) == ContextSignal.self, "emit() does not produce ContextSignal")
    }
    
    func testEmitStringSignal() {
        let value = 123
        emit(value)
        XCTAssertEqual(logger.recordings.count, 1, "String did not signal")
        let signal = logger.recordings.first as? WrapperSignal
        XCTAssertNotNil(signal, "emit() does not produce ContextSignal")
        XCTAssertEqual(signal!.value as? Int, value, "StringSignal did not capture emitting string")
    }
    
    func testErrorSignal() {
        do { try throwup() }
        catch {
            emit(error: error)
        }
        XCTAssertEqual(logger.recordings.count, 1, "Error did not signal")
        let signal = logger.recordings.first as? ErrorSignal
        XCTAssertNotNil(signal, "emit() does not produce ErrorSignal")
    }
    
    func testOptionalErrorSignal() {
        let err: Error? = nil
        emit(error: err)
        XCTAssertEqual(logger.recordings.count, 1, "Error did not signal")
        let signal = logger.recordings.first as? ContextSignal
        XCTAssertNotNil(signal, "emit() does not produce ContextSignal")
    }
    
    func testWrapperSignal() {
        emit(self)
        XCTAssertEqual(logger.recordings.count, 1, "WrapperSignal did not signal")
        let signal = logger.recordings.first as? WrapperSignal
        XCTAssertNotNil(signal, "emit() does not produce WrapperSignal")
        XCTAssertEqual(signal?.value as? SignalTests, self, "WrapperSignal did not capture its target")
    }
    
    func testEmitFromMainThread() {
        let expect = expectation(description: "Waiting for emit from main thread")
        DispatchQueue.main.async {
            emit(self)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1)
        let signal = logger.recordings.first as? WrapperSignal
        XCTAssertNotNil(signal, "emit() does not produce WrapperSignal")
        XCTAssertEqual(signal?.value as? SignalTests, self, "WrapperSignal did not capture its target")
    }
    
    func testEmitPerformance() {
        measure {
            emit()
        }
    }
    
    // MARK:- Scaling
    @inline(__always) private func perform(across count: Int, block: ()->Void) {
        let loggers: [MemoryLogger] = (1...count).map {
            return MemoryLogger.starting(name: "\($0)")
        }
        block()
        loggers.forEach { $0.stop() }
    }
    
    func testEmitSmallScaling() {
        perform(across: 10) {
            measure {
                emit()
            }
        }
    }
    
    func testEmitLargeScaling() {
        perform(across: 1000) {
            measure {
                emit()
            }
        }
    }
    
}
