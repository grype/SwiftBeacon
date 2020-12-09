//
//  FileWheelTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon

class FileWheelTests : XCTestCase {
    
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    func testInit() {
        let wheel = FileWheel(maxFileSize: UInt64(10)) { _ in return true }
        XCTAssertEqual(wheel.maxFileSize, UInt64(10), "Incorrectly set maxFileSize argument during init")
        XCTAssertNotNil(wheel.rotationBlock, "Rotation block was not set during init")
    }
    
    func testShouldRotateForZeroSize() {
        let wheel = FileWheel(maxFileSize: UInt64(10)) { _ in return true }
        let data = Data()
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not allow rotation for empty content")
    }
    
    func testShouldRotateWhenFileDoesNotExist() {
        let wheel = FileWheelStub(maxFileSize: UInt64(10)) { _ in return true }
        wheel.stubbedFileExistsResult = false
        let data = "a".data(using: .utf8)!
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not rotate when file doesn't exist")
    }
    
    func testShouldRotateWhenFileExceedsMaxSize() {
        let wheel = FileWheelStub(maxFileSize: UInt64(10)) { _ in return true }
        wheel.stubbedFileExistsResult = true
        wheel.stubbedFileSizeResult = UInt64(10)
        let data = "a".data(using: .utf8)!
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not rotate when file doesn't exist")
    }
    
    func testShouldRotateWhenFileWillExceedMaxSize() {
        let wheel = FileWheelStub(maxFileSize: UInt64(10)) { _ in return true }
        wheel.stubbedFileExistsResult = true
        wheel.stubbedFileSizeResult = UInt64(122)
        let data = "a".data(using: .utf8)!
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not rotate when file doesn't exist")
    }
    
    func testShouldRotateWhenFileIsEmpty() {
        let wheel = FileWheelStub(maxFileSize: UInt64()) { _ in return true }
        wheel.stubbedFileExistsResult = true
        wheel.stubbedFileSizeResult = UInt64(0)
        let data = "this should overflow".data(using: .utf8)!
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not rotate when file doesn't exist")
    }
    
    func testRotateInvokesBlock() {
        var rotated: Int = 0
        let wheel = FileWheel(maxFileSize: UInt64(10)) { _ in
            rotated += 1
            return true
        }
        let _ = wheel.rotate(fileAt: url)
        XCTAssertEqual(rotated, 1, "Rotation block should have been invoked once after calling rotate()")
    }
    
}
