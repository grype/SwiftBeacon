//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import XCTest
@testable import Beacon

class FileWheelTests : XCTestCase {
    
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    func testInit() {
        var wheel = FileWheel(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        XCTAssertTrue(wheel.rotateOnStart, "Incorretly set true onStart argument during init")
        XCTAssertEqual(wheel.maxFileSize, UInt64(123), "Incorrectly set maxFileSize argument during init")
        XCTAssertNotNil(wheel.rotationBlock, "Rotation block was not set during init")
        
        wheel = FileWheel(rotateOnStart: false, maxFileSize: UInt64(123)) { _ in }
        XCTAssertFalse(wheel.rotateOnStart, "Incorretly set true onStart argument during init")
    }
    
    func testShouldRotateOnStart() {
        var wheel = FileWheel(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        XCTAssertTrue(wheel.shouldRotate(fileAt: url, for: .start), "Should allow rotation on start when configured to do so")
        
        wheel = FileWheel(rotateOnStart: false, maxFileSize: UInt64(123)) { _ in }
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: .start), "Should not allow rotation on start when configured to do so")
    }
    
    func testShouldRotateForZeroSize() {
        let wheel = FileWheel(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: .put(size: 0)), "Should not allow rotation for empty content")
    }
    
    func testRotateWhenFileDoesNotExist() {
        let wheel = FileWheelStub(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        wheel.stubbedFileExistsResult = false
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: .put(size: 1)), "Should not rotate when file doesn't exist")
    }
    
    func testRotateWhenFileExceedsMaxSize() {
        let wheel = FileWheelStub(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        wheel.stubbedFileExistsResult = true
        wheel.stubbedFileSizeResult = UInt64(123)
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: .put(size: 1)), "Should not rotate when file doesn't exist")
    }
    
    func testRotateWhenFileWillExceedMaxSize() {
        let wheel = FileWheelStub(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in }
        wheel.stubbedFileExistsResult = true
        wheel.stubbedFileSizeResult = UInt64(122)
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: .put(size: 1)), "Should not rotate when file doesn't exist")
    }
    
    func testRotateInvokesBlock() {
        var rotated: Int = 0
        let wheel = FileWheel(rotateOnStart: true, maxFileSize: UInt64(123)) { _ in
            rotated += 1
        }
        wheel.rotate(fileAt: url)
        XCTAssertEqual(rotated, 1, "Rotation block should have been invoked once after calling rotate()")
    }
    
}
