//
//  FileWheelTests.swift
//
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

@testable import Beacon
import Combine
import Cuckoo
import Nimble
import XCTest

class FileWheelTests: XCTestCase {
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    var wheel: MockFileWheel!
    
    private var subject: PassthroughSubject<Signal, Never>!
    
    private var logger: MockFileLogger!
    
    override func setUp() {
        super.setUp()
        wheel = MockFileWheel(when: { _ in true }, rotate: { _ in }).withEnabledSuperclassSpy()
        logger = MockFileLogger(name: "Test logger", on: url, encoder: SignalDescriptionEncoder(encoding: .utf8))!.withEnabledSuperclassSpy()
        logger.wheel = wheel
        subject = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
        subject?.send(completion: .finished)
    }
    
    func testRotatesOnSubscription() {
        logger.rotateOnSubscription = true
        subject.subscribe(logger)
        stub(wheel) { stub in
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateOnSubscription() {
        logger.rotateOnSubscription = false
        subject.subscribe(logger)
        stub(wheel) { stub in
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
        verify(wheel, times(0)).rotate(fileAt: any())
    }
}
