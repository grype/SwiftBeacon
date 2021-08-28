//
//  FileWheelTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Cuckoo
import Nimble
@testable import Beacon

class FileWheelTests : XCTestCase {
    
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    var wheel: MockFileWheel!
    
    override func setUp() {
        super.setUp()
        wheel = MockFileWheel(when: { _ in true }, rotate: { _ in }).withEnabledSuperclassSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
    }
    
    func testRotatesWhenShould() {
        stub(wheel) { (stub) in
            when(stub.shouldRotate(fileAt: any())).thenReturn(true)
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
        logSignal()
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateWhenShouldNot() {
        stub(wheel) { (stub) in
            when(stub.shouldRotate(fileAt: any())).thenReturn(false)
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
        logSignal()
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    // MARK:- Helpers
    
    private func logSignal() {
        let logger = FileLogger(name: "Test logger", on: url, encoder: SignalDescriptionEncoder(encoding: .utf8))!
        logger.wheel = wheel
        logger.tracksMachImageImports = false
        logger.identifiesOnStart = false
        logger.run { _ in
            emit("Testing...")
        }
    }
    
}
