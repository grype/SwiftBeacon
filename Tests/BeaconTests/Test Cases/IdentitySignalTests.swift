//
//  IdentitySignalTests.swift
//  
//
//  Created by Pavel Skaldin on 5/7/21.
//

import XCTest
import Nimble
@testable import Beacon

class IdentitySignalTests : XCTestCase {
    
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.identifiesOnStart = true
        logger.tracksMachImageImports = false
        logger.start()
    }
    
    func testLoggerEmitsIdentitySignalOnStart() {
        expect(self.logger.recordings.count) == 1
        expect(self.logger.recordings.first!).to(beAKindOf(IdentitySignal.self))
    }
    
    func testIdentitySignalCapturesVersion() {
        let signal = logger.recordings.first as! IdentitySignal
        expect(signal.beaconVersion).toNot(beNil())
        expect(signal.beaconVersion).toNot(beEmpty())
        expect(signal.systemInfo).toNot(beNil())
    }
    
}
