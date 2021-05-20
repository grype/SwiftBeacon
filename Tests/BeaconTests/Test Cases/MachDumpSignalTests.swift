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
        expect(self.logger.recordings.count) == Int(MachImage.loadedImageCount)
    }
    
}
