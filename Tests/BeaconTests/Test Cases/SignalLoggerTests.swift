//
//  SignalLoggerTest.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/25/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

@testable import Beacon
import Combine
import Nimble
import XCTest

class SignalLoggerTests: XCTestCase {
    private var activeBeacon: PassthroughSubject<Signal, Never>!
    private var inactiveBeacon: PassthroughSubject<Signal, Never>!
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        activeBeacon = .init()
        inactiveBeacon = .init()
        logger = MemoryLogger(name: "Test logger")
    }
    
    override func tearDown() {
        super.tearDown()
        [activeBeacon, inactiveBeacon].forEach { $0?.send(completion: .finished) }
    }
    
    func testStart() {
        activeBeacon.subscribe(logger)
        expect(self.logger.recordings.count) == 0
        #emit(on: activeBeacon)
        expect(self.logger.recordings.count) == 1
    }
    
    func testInitAndStart() {
        let logger = MemoryLogger(name: "Another logger")
        activeBeacon.subscribe(logger)
        expect(logger.recordings.count) == 0
    }
    
    func testFilter() {
        activeBeacon.filter { $0 is ErrorSignal }.subscribe(logger)
        #emit(on: activeBeacon)
        expect(self.logger.recordings.count) == 0
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            #emit(error: error, on: activeBeacon)
        }
        expect(self.logger.recordings.count) == 1
    }
    
    func testMultipleBeaconSubscription() {
        [activeBeacon, inactiveBeacon].forEach { $0?.subscribe(logger) }
        #emit(on: activeBeacon)
        #emit(on: inactiveBeacon)
        expect(self.logger.recordings.count) == 2
    }
    
    func testMultipleSubscriptionsToSameBeacon() {
        [activeBeacon, activeBeacon].forEach { $0.subscribe(logger) }
        #emit(on: activeBeacon)
        expect(self.logger.recordings.count) == 2
    }
    
    func testMultipleSubscriptionsToSameBeaconWithDifferentFilters() {
        activeBeacon.filter { $0 is ContextSignal }.subscribe(logger)
        activeBeacon.filter { $0 is ErrorSignal }.subscribe(logger)
        #emit(on: activeBeacon)
        expect(self.logger.recordings.count) == 1
        do {
            throw NSError(domain: String(describing: type(of: self)), code: 0, userInfo: nil)
        }
        catch {
            #emit(error: error, on: activeBeacon)
            expect(self.logger.recordings.count) == 2
        }
    }
}
