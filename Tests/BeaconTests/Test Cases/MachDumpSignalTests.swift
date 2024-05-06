//
//  MachDumpSignalTests.swift
//
//
//  Created by Pavel Skaldin on 5/10/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Beacon
import Combine
import Nimble
import XCTest

class MachDumpSignalTests: XCTestCase {
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.limit = Int.max
    }
    
    override func tearDown() {
        super.tearDown()
        MachImageMonitor.shared.beacon.send(completion: .finished)
        MachImageMonitor.stopMonitoring()
    }
    
    func testLogsImage() {
        MachImageMonitor.shared.beacon.subscribe(logger)
        MachImageMonitor.startMonitoring()
        let found = logger.recordings.map { ($0 as! MachImageImportsSignal).added!.count }.reduce(into: 0) { total, value in
            total += value
        }
        expect(found) == MachImageMonitor.shared.images.count
    }
}
