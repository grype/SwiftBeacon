//
//  File.swift
//
//
//  Created by Pavel Skaldin on 9/16/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Beacon
import Nimble
import XCTest

class SignalFilteringTests: XCTestCase {
    private var logger: MemoryLogger!
    
    private var beacon: Beacon!
    
    override func setUp() {
        super.setUp()
        beacon = Beacon()
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.beForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        if logger.isRunning {
            logger.stop()
        }
        Signal.removeAllConstraints()
    }
    
    func throwup() throws {
        throw "User Test Error"
    }
    
    // MARK: - Query
    
    func testCannotLogByDefaultDueToLoggerNotRunning() {
        expect(self.logger.isRunning).to(beFalse())
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
    }
    
    func testCanLogByDefault() {
        logger.start(on: [beacon])
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
    }
    
    // MARK: - Filtering
    
    func testDisablesLoggingToLoggerAndBeacon() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger, on: beacon)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(self.logger.recordings).to(beEmpty())
    }
    
    func testEnablesLoggingToLoggerAndBeacon() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger, on: beacon)
        ContextSignal.enable(loggingTo: logger, on: beacon)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testDisablesLoggingToLoggerAndAllBeacons() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(self.logger.recordings).to(beEmpty())
    }
    
    func testEnablesLoggingToLoggerAndAllBeacons() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger)
        ContextSignal.enable(loggingTo: logger)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testDisablesAllLoggersOnBeacon() {
        logger.start(on: [beacon])
        ContextSignal.disable(on: beacon)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(self.logger.recordings).to(beEmpty())
    }
    
    func testEnablesAllLoggersOnBeacon() {
        logger.start(on: [beacon])
        ContextSignal.disable(on: beacon)
        ContextSignal.enable(on: beacon)
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testDisablesAllLoggersOnAllBeacons() {
        logger.start(on: [beacon])
        ContextSignal.disable()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(self.logger.recordings).to(beEmpty())
    }
    
    func testEnablesAllLoggersOnAllBeacons() {
        logger.start(on: [beacon])
        ContextSignal.disable()
        ContextSignal.enable()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testDisableAllLogging() {
        logger.start(on: [beacon])
        Signal.disable()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(willLog(type: StringSignal.self, on: [self.beacon])).to(beFalse())
        emit("string", on: beacon)
        expect(self.logger.recordings).to(beEmpty())
    }
    
    func testEnableAllLogging() {
        logger.start(on: [beacon])
        Signal.disable()
        Signal.enable()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(willLog(type: StringSignal.self, on: [self.beacon])).to(beTrue())
        emit("string", on: beacon)
        expect(self.logger.recordings.count) == 2
    }
    
    func testDisableSomeEnableAll() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger, on: beacon)
        Signal.enable()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beFalse())
        emit(on: beacon)
        expect(willLog(type: StringSignal.self, on: [self.beacon])).to(beTrue())
        emit("string", on: beacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testOneSignalDoesNotDisableOthers() {
        logger.start(on: [beacon])
        ContextSignal.disable(loggingTo: logger)
        emit("Not disabled", on: beacon)
        expect(self.logger.recordings.count) == 1
        guard let loggedSignal = logger.recordings.first else { return }
        expect(type(of: loggedSignal) == StringSignal.self).to(beTrue())
        logger.stop()
    }
    
    func testRemovingAllConstraints() {
        logger.start(on: [beacon])
        Signal.disable()
        Signal.removeAllConstraints()
        expect(willLog(type: ContextSignal.self, on: [self.beacon])).to(beTrue())
        emit(on: beacon)
        expect(self.logger.recordings.count) == 1
    }
}
