//
//  FileLoggerTests.swift
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

class FileLoggerTests: XCTestCase {
    private var logger: FileLogger!
    
    private var subject: PassthroughSubject<Signal, Never>!
    
    private let url = URL(fileURLWithPath: "/tmp/FileLoggerTests.log")
    
    private var wheel: MockFileWheel!
    
    private var publisher: PassthroughSubject<Signal, Error>!
    
    override func setUp() {
        super.setUp()
        
        publisher = .init()
        
        wheel = MockFileWheel(when: { _ -> Bool in
            true
        }, rotate: { _ in
        }).withEnabledSuperclassSpy()
        
        logger = FileLogger(name: "FileLoggerTests", on: url, encoder: SignalDescriptionEncoder(encoding: .utf8))
        logger.wheel = wheel
        
        subject = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        subject.send(completion: .finished)
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
        logger.rotateOnSubscription = true
        subject.subscribe(logger)
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testRotateOnStartWhenWheelShouldNot() {
        stubForRotation(false)
        logger.rotateOnSubscription = true
        subject.subscribe(logger)
        verify(wheel, times(1)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateOnStartWhenWheelShould() {
        stubForRotation(true)
        logger.rotateOnSubscription = false
        subject.subscribe(logger)
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    func testDoesNotRotateOnStartWhenWheelShouldNot() {
        stubForRotation(false)
        logger.rotateOnSubscription = false
        subject.subscribe(logger)
        verify(wheel, times(0)).rotate(fileAt: any())
    }
    
    // MARK: - Helpers
    
    private func logSignal() {
        subject.send(StringSignal("\(Date())"))
    }
    
    private func stubForRotation(_ bool: Bool) {
        stub(wheel) { stub in
            when(stub.shouldRotate(fileAt: any())).thenReturn(bool)
            when(stub.rotate(fileAt: any())).thenDoNothing()
        }
    }
}
