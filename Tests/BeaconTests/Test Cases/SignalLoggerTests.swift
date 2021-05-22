//
//  SignalLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/25/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class SignalLoggerTests: XCTestCase {
    
    private var activeBeacon: Beacon!
    private var inactiveBeacon: Beacon!
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        activeBeacon = Beacon()
        inactiveBeacon = Beacon()
        logger = MemoryLogger(name: "Test logger")
        logger.beForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    func testInit() {
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testStart() {
        logger.start(on: [activeBeacon])
        expect(self.logger.isRunning).to(beTrue())
        expect(self.logger.recordings.count) == 0
        emit(on: [activeBeacon])
        expect(self.logger.recordings.count) == 1
    }
    
    func testInitAndStart() {
        let logger: MemoryLogger = MemoryLogger.starting(name: "Another logger", on: [activeBeacon])
        logger.beForTesting()
        expect(logger.isRunning).to(beTrue())
        expect(logger.recordings.count) == 2
    }
    
    func testStartStop() {
        logger.start()
        logger.stop()
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testStartStopOnBeacon() {
        logger.start(on: [activeBeacon])
        logger.stop(on: [activeBeacon])
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testStopAll() {
        logger.stop()
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testFilter() {
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        emit(on: [activeBeacon])
        expect(self.logger.recordings.count) == 0
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            emit(error: error, on: [activeBeacon, inactiveBeacon])
        }
        expect(self.logger.recordings.count) == 1
    }
    
    func testRunDuring() {
        logger.run(on: [activeBeacon]) { _ in
            expect(self.logger.isRunning).to(beTrue())
            emit(on: [activeBeacon])
            expect(self.logger.recordings.count) == 1
        }
        expect(self.logger.isRunning).to(beFalse())
        expect(self.logger.recordings.count) == 1
    }
    
    func testRunForSignals() {
        logger.run(for: [ErrorSignal.self, WrapperSignal.self], on: [activeBeacon]) { (_) in
            expect(self.logger.isRunning).to(beTrue())
            emit(on: [activeBeacon])
            expect(self.logger.recordings.count) == 0
            
            emit(1, on: [activeBeacon])
            expect(self.logger.recordings.count) == 1
            
            do {
                throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
            }
            catch {
                emit(error: error, on: [activeBeacon])
            }
            expect(self.logger.recordings.count) == 2
        }
        expect(self.logger.isRunning).to(beFalse())
    }
    
    func testMultipleBeaconSubscription() {
        logger.start(on: [activeBeacon, inactiveBeacon])
        expect(self.logger.isRunning).to(beTrue())
        emit(on: [activeBeacon, inactiveBeacon])
        expect(self.logger.recordings.count) == 2
    }
    
    func testMultipleSubscriptionsToSameBeacon() {
        logger.start(on: [activeBeacon])
        logger.start(on: [activeBeacon])
        expect(self.logger.isRunning).to(beTrue())
        emit(on: [activeBeacon])
        expect(self.logger.recordings.count) == 1
    }
    
    func testMultipleSubscriptionsToSameBeaconWithDifferentFilters() {
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ContextSignal
        }
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        expect(self.logger.isRunning).to(beTrue())
        emit(on: [activeBeacon])
        expect(self.logger.recordings.count) == 0
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            emit(error: error, on: [activeBeacon])
            expect(self.logger.recordings.count) == 1
        }
    }
}
