//
//  PublisherEmitTests.swift
//
//
//  Created by Pavel Skaldin on 5/8/24.
//

@testable import Beacon
import Combine
import Nimble
import XCTest

fileprivate var InitialStringValue = "Initial"

final class PublisherEmitTests: XCTestCase {
    var logger: MemoryLogger!

    @Published var stringValue: String = InitialStringValue
    
    @Published var optionalStringValue: String? = InitialStringValue

    override func setUp() {
        super.setUp()
        logger = .init(name: "PublisherEmitTests")
    }

    override func tearDown() {
        super.tearDown()
        logger = nil
    }
    
    func testInitialStringValueEmitted() {
        $stringValue.emit(on: logger)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first!
        expect(signal).to(beAKindOf(StringSignal.self))
        expect((signal as? StringSignal)?.message) == InitialStringValue
    }

    func testChangedStringValue() {
        $stringValue.emit(on: logger)
        stringValue = "Changed"
        expect(self.logger.recordings.count) == 2
        let signal = logger.recordings.last!
        expect(signal).to(beAKindOf(StringSignal.self))
        expect((signal as? StringSignal)?.message) == "Changed"
    }
    
    func testInitialOptionalStringValueEmitted() {
        $stringValue.emit(on: logger)
        expect(self.logger.recordings.count) == 1
        let signal = logger.recordings.first!
        expect(signal).to(beAKindOf(StringSignal.self))
        expect((signal as? StringSignal)?.message) == InitialStringValue
    }

    func testChangedOptionalStringValue() {
        $stringValue.emit(on: logger)
        stringValue = "Changed"
        expect(self.logger.recordings.count) == 2
        let signal = logger.recordings.last!
        expect(signal).to(beAKindOf(StringSignal.self))
        expect((signal as? StringSignal)?.message) == "Changed"
    }
}
