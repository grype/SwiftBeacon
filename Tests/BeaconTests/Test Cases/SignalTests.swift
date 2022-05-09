//
//  SignalTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class SignalTests : XCTestCase {
    
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.beForTesting()
        logger.start()
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    func throwup() throws {
        throw "User Test Error"
    }
    
    // MARK:- Emitting various signals
    
    func testEmitContextSignal() {
        emit()
        let logger = self.logger!
        expect(logger.recordings.count) == 1
        let signal = logger.recordings.first!
        expect(type(of: signal) == ContextSignal.self).to(beTrue())
    }
    
    func testEmitStringSignal() {
        let value = 123
        emit(value)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? WrapperSignal
        expect(signal).toNot(beNil())
        expect(signal!.value as? Int) == value
    }
    
    func testErrorSignal() {
        do { try throwup() }
        catch {
            emit(error: error)
        }
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? ErrorSignal
        expect(signal).toNot(beNil())
    }
    
    func testOptionalErrorSignal() {
        let err: Error? = nil
        emit(error: err)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? ContextSignal
        expect(signal).toNot(beNil())
    }
    
    func testWrapperSignal() {
        emit(self)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? WrapperSignal
        expect(signal).toNot(beNil())
        expect(signal?.value as? SignalTests) == self
    }
    
    // MARK:- Threading
    
    func testEmitFromMainThread() {
        waitUntil { done in
            DispatchQueue.main.async {
                emit(self)
                done()
            }
        }
        let signal = logger.recordings.first as? WrapperSignal
        expect(signal).toNot(beNil())
        expect(signal?.value as? SignalTests) == self
    }
    
    // MARK:- Performance
    
    func testEmitPerformance() {
        measure {
            emit()
        }
    }
    
    // MARK:- Scaling
    @inline(__always) private func perform(across count: Int, block: ()->Void) {
        let loggers: [MemoryLogger] = (1...count).map {
            let logger = MemoryLogger(name: "\($0)")
            logger.beForTesting()
            return logger
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
