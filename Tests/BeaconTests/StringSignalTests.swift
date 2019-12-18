//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/17/19.
//

import XCTest
import Beacon

class StringSignalTest : XCTestCase, Error {
    
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
        assert(logger.recordings.first != nil, "emit() did not produce an artifact")
        let signal = logger.recordings.first!
        assert(type(of: signal) == StringSignal.self, "emit() did not produce StringSignal")
        let stringSignal = signal as! StringSignal
        assert(stringSignal.message == message, "emit() produce StringSignal without matching message")
        assert(stringSignal.userInfo == nil, "emit() resulted in incorrect userInfo")
    }
    
    func testEmitStringWithUserInfo() {
        let userInfo: [String:String] = ["Hello" : "World"]
        emit(message, userInfo: userInfo)
        let signal = logger.recordings.first!
        print(signal.description)
        assert(type(of: signal) == StringSignal.self, "emit() did not produce StringSignal")
        let stringSignal = signal as! StringSignal
        assert(stringSignal.message == message, "emit() produce StringSignal without matching message")
        assert(stringSignal.userInfo as? [String:String] == userInfo, "emit() resulted in incorrect userInfo")
    }
}
