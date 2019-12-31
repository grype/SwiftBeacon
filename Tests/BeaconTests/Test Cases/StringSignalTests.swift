//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/17/19.
//

import XCTest
import Beacon

class StringSignalTests : XCTestCase, Error {
    
    private var logger: MemoryLogger!
    
    private let message = "Just a string"
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger.starting(name: "BeaconTestLogger")
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    func testEmitStringOnly() {
        emit(message)
        XCTAssertNotNil(logger.recordings.first, "emit() did not produce an artifact")
        let signal = logger.recordings.first!
        XCTAssertTrue(type(of: signal) == StringSignal.self, "emit() did not produce StringSignal")
        let stringSignal = signal as! StringSignal
        XCTAssertEqual(stringSignal.message, message, "emit() produce StringSignal without matching message")
        XCTAssertNil(stringSignal.userInfo, "emit() resulted in incorrect userInfo")
    }
    
    func testEmitStringWithUserInfo() {
        let userInfo: [String:String] = ["Hello" : "World"]
        emit(message, userInfo: userInfo)
        let signal = logger.recordings.first!
        print(signal.description)
        XCTAssertTrue(type(of: signal) == StringSignal.self, "emit() did not produce StringSignal")
        let stringSignal = signal as! StringSignal
        XCTAssertEqual(stringSignal.message, message, "emit() produce StringSignal without matching message")
        XCTAssertEqual(stringSignal.userInfo as? [String:String], userInfo, "emit() resulted in incorrect userInfo")
    }
}
