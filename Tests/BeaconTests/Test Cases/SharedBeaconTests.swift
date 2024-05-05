//
//  File.swift
//
//
//  Created by Pavel Skaldin on 5/3/24.
//

@testable import Beacon
import Combine
import Foundation
import XCTest

private var Beacon: PassthroughSubject<Signal, Never>!

class SharedBeaconTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        Beacon = nil
    }

    func testOverride() {
        Beacon = .init()
        assert(OriginalModuleBeacon !== Beacon, "Global Beacon should be overriden")
    }
}
