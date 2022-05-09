//
//  StringSignalTests.swift
//  
//
//  Created by Pavel Skaldin on 12/17/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class StringSignalTests : XCTestCase {
    
    private var logger: MemoryLogger!
    
    private let message = "Just a string"
    
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
    
    func testEmitStringOnly() {
        emit(message)
        let logger = self.logger!
        expect(logger.recordings.first).toNot(beNil())
        let signal = logger.recordings.first!
        expect(type(of: signal) == StringSignal.self).to(beTrue())
        let stringSignal = signal as! StringSignal
        expect(stringSignal.message).to(equal(message))
        expect(stringSignal.userInfo).to(beNil())
    }
    
    func testEmitStringWithUserInfo() {
        let userInfo: [String:String] = ["Hello" : "hello, hello...", "Is There" : "Anybody Out There"]
        emit(message, userInfo: userInfo)
        let logger = self.logger!
        let signal = logger.recordings.first!
        expect(type(of: signal) == StringSignal.self).to(beTrue())
        let stringSignal = signal as! StringSignal
        expect(stringSignal.message).to(equal(message))
        expect(stringSignal.userInfo as? [String:String]).to(equal(userInfo))
        expect(stringSignal.userInfoDescription).toNot(beNil())
    }
    
    func testStringSignalDescription() {
        let userInfo: [String:String] = ["Hello" : "hello, hello...", "Is There" : "Anybody Out There"]
        emit(message, userInfo: userInfo)
        let logger = self.logger!
        let stringSignal = logger.recordings.first as! StringSignal
        print(stringSignal.description)
        expect(stringSignal.sourceDescription).toNot(beNil())
        expect(stringSignal.userInfoDescription).toNot(beNil())
        expect(stringSignal.description.contains(stringSignal.userInfoDescription!)).to(beFalse())
        print(stringSignal.debugDescription)
        expect(stringSignal.debugDescription.contains(stringSignal.userInfoDescription!)).to(beTrue())
    }
}
