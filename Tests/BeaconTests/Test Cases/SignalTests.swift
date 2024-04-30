//
//  SignalTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 1/29/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
import Combine
@testable import Beacon

class SignalTests : XCTestCase {
    
    private var logger: MemoryLogger!
    
    private var subject: PassthroughSubject<Signal, Never>!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        subject.subscribe(logger)
    }
    
    override func tearDown() {
        super.tearDown()
        subject.send(completion: .finished)
    }
    
    func throwup() throws {
        throw "User Test Error"
    }
    
    // MARK:- Emitting various signals
    
    func testEmitContextSignal() {
        #emit(on: subject)
        let logger = self.logger!
        expect(logger.recordings.count) == 1
        let signal = logger.recordings.first!
        expect(type(of: signal) == ContextSignal.self).to(beTrue())
    }
    
    func testEmitStringSignal() {
        let value = 123
        #emit(value, on: subject)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? WrapperSignal
        expect(signal).toNot(beNil())
        expect(signal!.value as? Int) == value
    }
    
    func testErrorSignal() {
        do { try throwup() }
        catch {
            #emit(error: error, on: subject)
        }
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? ErrorSignal
        expect(signal).toNot(beNil())
    }
    
    func testWrapperSignal() {
        #emit(self, on: subject)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first as? WrapperSignal
        expect(signal).toNot(beNil())
        expect(signal?.value as? SignalTests) == self
    }
    
    // MARK:- Threading
    
    func testEmitFromMainThread() {
        waitUntil { done in
            DispatchQueue.main.async {
                #emit(self, on: subject)
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
            #emit()
        }
    }
    
    // MARK:- Scaling
    @inline(__always) private func perform(across count: Int, block: ()->Void) {
        let loggers: [MemoryLogger] = (1...count).map {
            return MemoryLogger(name: "\($0)")
        }
        block()
        subject.send(completion: .finished)
    }
    
    func testEmitSmallScaling() {
        perform(across: 10) {
            measure {
                #emit(on: self.subject)
            }
        }
    }
    
    func testEmitLargeScaling() {
        perform(across: 1000) {
            measure {
                #emit(on: self.subject)
            }
        }
    }
    
}
