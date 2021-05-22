//
//  FileLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
import Cuckoo
@testable import Beacon

class FileLoggerTests : XCTestCase {
    
    private var logger: FileLogger!
    
    private let url = URL(fileURLWithPath: "/tmp/FileLoggerTests.log")
    
    private var wheel: MockFileWheel!
    
    override func setUp() {
        super.setUp()
        
        wheel = MockFileWheel(when: { (_, _) -> Bool in
            return true
        }, rotate: { (_) in
        }).withEnabledSuperclassSpy()
        
        logger = FileLogger(name: "FileLoggerTests", on: url, encoder: SignalStringEncoder(encoding: .utf8))
        logger.wheel = wheel
        logger.beForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
        logger = nil
    }
    
    func testRotates() {
        stubForRotation(true)
        logSignal()
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testDoesNotRotate() {
        stubForRotation(false)
        logSignal()
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    func testRotateOnStartWhenWheelShould() {
        stubForRotation(true)
        logger.rotateOnStart = true
        logger.start()
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testRotateOnStartWhenWheelShouldNot() {
        stubForRotation(false)
        logger.rotateOnStart = true
        logger.start()
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateOnStartWhenWheelShould() {
        stubForRotation(true)
        logger.rotateOnStart = false
        logger.start()
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateOnStartWhenWheelShouldNot() {
        stubForRotation(false)
        logger.rotateOnStart = false
        logger.start()
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    // MARK:- Helpers
    
    private func logSignal() {
        logger.run { (aLogger) in
            aLogger.nextPut(StringSignal("\(Date())"))
        }
    }
    
    private func stubForRotation(_ bool: Bool) {
        stub(wheel) { (stub) in
            when(stub.shouldRotate(fileAt: any(), for: any())).thenReturn(bool)
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
    }
    
}
