//
//  ContextSignalTests.swift
//
//
//  Created by Pavel Skaldin on 4/28/21.
//

@testable import Beacon
import Combine
import Foundation
import Nimble
import XCTest

class ContextSignalTests: XCTestCase {
    private var logger: MemoryLogger!
    private var subject: PassthroughSubject<Signal, Never>!
    private let message = "Just a string"
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        subject = .init()
        subject.subscribe(logger)
    }
    
    override func tearDown() {
        super.tearDown()
        subject.send(completion: .finished)
    }
    
    func testEmitStringOnly() {
        #emit("Hello", on: subject)
        #emit(on: subject)
        let signal = logger.recordings.first
        expect(self.logger.recordings.count) == 1
        expect(signal).to(beAKindOf(ContextSignal.self))
    }
    
    func testSymbols() {
        #emit()
        let signal = logger.recordings.first as! ContextSignal
        expect(signal.symbols).toNot(beEmpty())
    }
    
    func testJsonSerialization() {
        #emit(on: subject)
        let signal = logger.recordings.first as! ContextSignal
        let json = try! JSONEncoder().encode(signal)
        let jsonObject = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String: Any]
        let symbols = jsonObject["symbols"] as! [String: [Int]]
        expect(symbols).toNot(beNil())
        expect(symbols) == signal.symbols
    }
}
