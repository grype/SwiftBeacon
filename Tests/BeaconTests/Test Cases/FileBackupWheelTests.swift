//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 5/20/21.
//

import XCTest
import Cuckoo
import Nimble
@testable import Beacon

class FileBackupWheelTests : XCTestCase {
    
    let url = URL(fileURLWithPath: "/tmp/FileWheelTests.log")
    
    var wheel: MockFileBackupWheel!
    
    var maxSize: UInt64 = 10
    
    override func setUp() {
        super.setUp()
        wheel = MockFileBackupWheel(maxFileSize: maxSize, maxNumberOfBackups: 2).withEnabledSuperclassSpy()
    }
    
    func testInit() {
        expect(self.wheel.maxFileSize) == 10
        expect(self.wheel.maxNumberOfBackups) == 2
    }
    
    func testShouldRotateForZeroSize() {
        let data = Data()
        XCTAssertFalse(wheel.shouldRotate(fileAt: url, for: data), "Should not allow rotation for empty content")
    }
    
    func testShouldNotRotateWhenFileDoesNotExist() {
        configureFile(exists: false)
        let data = "a".data(using: .utf8)!
        expect(self.wheel.shouldRotate(fileAt: self.url, for: data)).to(beFalse())
    }
    
    func testShouldRotateWhenFileExceedsMaxSize() {
        configureFile(exists: true, size: maxSize)
        let data = "a".data(using: .utf8)!
        expect(self.wheel.shouldRotate(fileAt: self.url, for: data)).to(beTrue())
    }
    
    func testShouldRotateWhenFileWillExceedMaxSize() {
        configureFile(exists: true, size: maxSize+1)
        let data = "a".data(using: .utf8)!
        expect(self.wheel.shouldRotate(fileAt: self.url, for: data)).to(beTrue())
    }
    
    func testShouldNotRotateWhenFileWillNotExceedMaxSize() {
        let data = "a".data(using: .utf8)!
        configureFile(exists: true, size: maxSize-UInt64(data.count+1))
        expect(self.wheel.shouldRotate(fileAt: self.url, for: data)).to(beFalse())
    }
    
    func testShouldRotateWhenFileIsEmpty() {
        configureFile(exists: true, size: 0)
        let data = "this should overflow".data(using: .utf8)!
        expect(self.wheel.shouldRotate(fileAt: self.url, for: data)).to(beFalse())
    }
    
    func testReducesExcessivesBackups() {
        wheel.fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        
        try! wheel.backupFile(at: url)
        var backups = try! wheel.backupsOfFile(at: url)
        expect(backups.count) == 1
        
        wheel.fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        try! wheel.backupFile(at: url)
        backups = try! wheel.backupsOfFile(at: url)
        expect(backups.count) == 2
        
        wheel.fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        try! wheel.backupFile(at: url)
        backups = try! wheel.backupsOfFile(at: url)
        expect(backups.count) == 2
        
        backups.forEach { (aURL) in
            try? wheel.fileManager.removeItem(at: aURL)
        }
    }
    
    // MARK:- Configuring
    
    private func configureFile(exists: Bool, size: UInt64 = 0) {
        stub(wheel) { (stub) in
            when(stub.fileExists(at: any())).thenReturn(exists)
            if exists {
                when(stub.fileSize(at: any())).thenReturn(size)
            }
        }
    }
    
}
