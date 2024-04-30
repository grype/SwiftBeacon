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
import Combine
@testable import Beacon

class FileWheelTests : XCTestCase {
    
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    var wheel: MockFileWheel!
    
    private var subject: PassthroughSubject<Signal, Never>!
    
    override func setUp() {
        super.setUp()
        wheel = MockFileWheel(when: { _ in true }, rotate: { _ in }).withEnabledSuperclassSpy()
        subject = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
        subject.send(completion: .finished)
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
        subject.subscribe(logger)
        #emit("Testing...", on: subject)
    }
    
}
