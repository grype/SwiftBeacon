//
//  SignalTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest

class SignalTest : XCTestCase, Error {
    
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
        assert(logger.recordings.count == 1, "Context did not signal")
        let signal = logger.recordings.first!
        assert(type(of: signal) == ContextSignal.self, "emit() does not produce ContextSignal")
    }
    
    func testEmitStringSignal() {
        let value = 123
        emit(value)
        assert(logger.recordings.count == 1, "String did not signal")
        let signal = logger.recordings.first as? WrapperSignal
        assert(signal != nil, "emit() does not produce ContextSignal")
        assert(signal!.value as? Int == value, "StringSignal did not capture emitting string")
    }
    
    func testErrorSignal() {
        do { try throwup() }
        catch {
            emit(error: error)
        }
        assert(logger.recordings.count == 1, "Error did not signal")
        let signal = logger.recordings.first as? ErrorSignal
        assert(signal != nil, "emit() does not produce ErrorSignal")
    }
    
    func testWrapperSignal() {
        emit(self)
        assert(logger.recordings.count == 1, "WrapperSignal did not signal")
        let signal = logger.recordings.first as? WrapperSignal
        assert(signal != nil, "emit() does not produce WrapperSignal")
        assert(signal?.value as? SignalTest == self, "WrapperSignal did not capture its target")
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
