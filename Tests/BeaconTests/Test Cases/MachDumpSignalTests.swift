//
//  MachDumpSignalTests.swift
//  
//
//  Created by Pavel Skaldin on 5/10/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class MachDumpSignalTests : XCTestCase {
    
    private var logger: MemoryLogger!
    
    override func setUp() {
        super.setUp()
        logger = MemoryLogger(name: "BeaconTestLogger")
        logger.identifiesOnStart = false
        logger.start()
    }
    
    func testLogsImage() {
        MachImageMonitor.startMonitoring()
        let found = logger.recordings.map { ($0 as! MachImageImportsSignal).added!.count }.reduce(into: 0) { (total, value) in
            total += value
        }
        expect(found) == Int(MachImage.loadedImageCount)
    }
    
}
