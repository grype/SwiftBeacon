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

class SharedBeaconTests2: XCTestCase {
    func testNoOverride() {
        assert(OriginalModuleBeacon === Beacon, "Global Beacon should be overriden")
    }
}
