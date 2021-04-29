//
//  ContextSignalTests.swift
//  
//
//  Created by Pavel Skaldin on 4/28/21.
//

import Foundation
import XCTest
import Nimble
@testable import Beacon

class ContextSignalTests : XCTestCase {
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
        emit()
        expect(self.logger.recordings.first).toNot(beNil())
        let signal = logger.recordings.first!
        expect(signal).to(beAKindOf(ContextSignal.self))
    }
}
