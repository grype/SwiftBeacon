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
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.identifiesOnStart = false
        logger.start()
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
    
    func testSymbols() {
        emit()
        let signal = logger.recordings.first as! ContextSignal
        expect(signal.symbols).toNot(beEmpty())
    }
    
    func testJsonSerialization() {
        emit()
        let signal = logger.recordings.first as! ContextSignal
        let json = try! JSONEncoder().encode(signal)
        let jsonObject = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String: Any]
        let symbols = jsonObject["symbols"] as! [String: [Int]]
        expect(symbols).toNot(beNil())
        expect(symbols) == signal.symbols
    }
}
