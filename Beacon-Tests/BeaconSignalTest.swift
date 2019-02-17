//
//  BeaconSignalTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest

class BeaconSignalTest : XCTestCase, Error {
    
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        Beacon.shared.add(logger, start: true)
    }
    
    override func tearDown() {
        super.tearDown()
        Beacon.shared.removeAllLoggers()
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
        let string = "I am a test string"
        emit(string)
        assert(logger.recordings.count == 1, "String did not signal")
        let signal = logger.recordings.first as? WrapperSignal
        assert(signal != nil, "emit() does not produce ContextSignal")
        assert(signal!.value as? String == string, "StringSignal did not capture emitting string")
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
        assert(signal?.value as? BeaconSignalTest == self, "WrapperSignal did not capture its target")
    }
    
    func testEmitPerformance() {
        measure {
            emit()
        }
    }
    
    // MARK:- Scaling
    @inline(__always) private func perform(across count: Int, block: ()->Void) {
        (1...count).forEach {
            let logger = MemoryLogger(name: "\($0)")
            logger.start()
            Beacon.shared.add(logger)
        }
        block()
        Beacon.shared.removeAllLoggers()
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
