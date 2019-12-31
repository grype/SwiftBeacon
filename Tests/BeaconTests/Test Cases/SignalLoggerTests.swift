//
//  SignalLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/25/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Beacon

class SignalLoggerTests: XCTestCase {
    
    private var activeBeacon: Beacon!
    private var inactiveBeacon: Beacon!
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        activeBeacon = Beacon()
        inactiveBeacon = Beacon()
        logger = MemoryLogger(name: "test logger")
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    func testInit() {
        XCTAssertFalse(logger.isRunning, "Logger shouldn't be running after basic instantiation")
    }
    
    func testStart() {
        logger.start(on: [activeBeacon])
        XCTAssertTrue(logger.isRunning, "Logger should be running when start()ed")
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 1, "Logger should have recorded one signal")
    }
    
    func testInitAndStart() {
        let logger: MemoryLogger = MemoryLogger.starting(name: "Another logger", on: [activeBeacon])
        XCTAssertTrue(logger.isRunning, "Logger should have been started")
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 1, "Logger should have recorded one signal")
    }
    
    func testStartStop() {
        logger.start()
        logger.stop()
        XCTAssertFalse(logger.isRunning, "Logger should not be running after calling stop()")
    }
    
    func testStop() {
        logger.start(on: [activeBeacon])
        logger.stop(on: [activeBeacon])
    }
    
    func testStopAll() {
        logger.stop()
        XCTAssertFalse(logger.isRunning, "Logger should not be running after calling stop()")
    }
    
    func testStartOnBeacon() {
        logger.start(on: [activeBeacon])
        XCTAssertTrue(logger.isRunning, "Logger should be running after start(on:)")
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 1, "Logger should have recorded one signal")
        emit(on: [inactiveBeacon])
        XCTAssertEqual(logger.recordings.count, 1, "Logger should not have recorded signals emitted on irrelevant beacon")
    }
    
    func testFilter() {
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 0, "Logger shouldn't have logged irrelevant signal")
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            emit(error: error, on: [activeBeacon, inactiveBeacon])
        }
        XCTAssertEqual(logger.recordings.count, 1, "Logger should have logged exactly one error signal")
    }
    
    func testRunDuring() {
        logger.run(on: [activeBeacon]) { _ in
            XCTAssertTrue(logger.isRunning, "Logger should have been started for running a block")
            emit(on: [activeBeacon])
            XCTAssertEqual(logger.recordings.count, 1, "Logger should have logged exactly one signal")
        }
        XCTAssertFalse(logger.isRunning, "Logger should have been stopped aftter running a block")
        XCTAssertEqual(logger.recordings.count, 1, "Logger should still have one recording")
    }
    
    func testRunForSignals() {
        logger.run(for: [ErrorSignal.self, WrapperSignal.self], on: [activeBeacon]) { (_) in
            XCTAssertTrue(logger.isRunning, "Logger should have been started for running a block")
            emit(on: [activeBeacon])
            XCTAssertEqual(self.logger.recordings.count, 0, "Logger logged a signal it was supposed to ignore")
            
            emit(1, on: [activeBeacon])
            XCTAssertEqual(logger.recordings.count, 1, "Logger should have logged wrapper signal")
            
            do {
                throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
            }
            catch {
                emit(error: error, on: [activeBeacon])
            }
            XCTAssertEqual(logger.recordings.count, 2, "Logger should have logged error signal")
        }
        XCTAssertFalse(logger.isRunning, "Logger should have stopped after running for duration of a run-block")
    }
    
    func testMultipleBeaconSubscription() {
        logger.start(on: [activeBeacon, inactiveBeacon])
        XCTAssertTrue(logger.isRunning, "Logger should be running when started with multiple beacons")
        emit(on: [activeBeacon, inactiveBeacon])
        XCTAssertEqual(logger.recordings.count, 2, "Logger should have recorded signal as many times as its subscribed beacons")
    }
    
    func testMultipleSubscriptionsToSameBeacon() {
        logger.start(on: [activeBeacon])
        logger.start(on: [activeBeacon])
        XCTAssertTrue(logger.isRunning, "Logger should be running after starting on the same beacon")
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 1, "Logger should have recorded one signal despite being started multiple times on the same beacon")
    }
    
    func testMultipleSubscriptionsToSameBeaconWithDifferentFilters() {
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ContextSignal
        }
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        XCTAssertTrue(logger.isRunning, "Logger should be running after starting on the same beacon")
        emit(on: [activeBeacon])
        XCTAssertEqual(logger.recordings.count, 0, "Logger should not have recorded context signal after it was re-subscribed to the same beacon with different filter")
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            emit(error: error, on: [activeBeacon])
            XCTAssertEqual(logger.recordings.count, 1, "Logger should have recorded error signal b/c due to re-subscription with error-filtering function")
        }
    }
}
