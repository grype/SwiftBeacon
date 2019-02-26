//
//  SignalLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/25/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest

class SignalLoggerTest: XCTestCase {
    
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
        assert(!logger.isRunning, "Logger shouldn't be running after basic instantiation")
    }
    
    func testStart() {
        logger.start(on: [activeBeacon])
        assert(logger.isRunning, "Logger should be running when start()ed")
        emit(on: [activeBeacon])
        assert(logger.recordings.count == 1, "Logger should have recorded one signal")
    }
    
    func testStop() {
        logger.stop()
        assert(!logger.isRunning, "Logger should not be running after calling stop()")
    }
    
    func testStartStop() {
        logger.start()
        logger.stop()
        assert(!logger.isRunning, "Logger should not be running after calling stop()")
    }
    
    func testStartOnBeacon() {
        logger.start(on: [activeBeacon])
        assert(logger.isRunning, "Logger should be running after start(on:)")
        emit(on: [activeBeacon])
        assert(logger.recordings.count == 1, "Logger should have recorded one signal")
        emit(on: [inactiveBeacon])
        assert(logger.recordings.count == 1, "Logger should not have recorded signals emitted on irrelevant beacon")
    }
    
    func testFilter() {
        logger.start(on: [activeBeacon]) { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        emit(on: [activeBeacon])
        assert(logger.recordings.count == 0, "Logger shouldn't have logged irrelevant signal")
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            emit(error: error, on: [activeBeacon, inactiveBeacon])
        }
        assert(logger.recordings.count == 1, "Logger should have logged exactly one error signal")
    }
}
