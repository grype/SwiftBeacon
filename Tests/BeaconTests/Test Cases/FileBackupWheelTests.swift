//
//  FileBackupWheelTests.swift
//
//
//  Created by Pavel Skaldin on 5/20/21.
//

@testable import Beacon
import Cuckoo
import Nimble
import XCTest

class FileBackupWheelTests: XCTestCase {
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
        XCTAssertFalse(wheel.shouldRotate(fileAt: url), "Should not allow rotation for empty content")
    }
    
    func testShouldNotRotateWhenFileDoesNotExist() {
        configureFile(exists: false)
        expect(self.wheel.shouldRotate(fileAt: self.url)).to(beFalse())
    }
    
    func testShouldRotateWhenFileExceedsMaxSize() {
        configureFile(exists: true, size: maxSize)
        expect(self.wheel.shouldRotate(fileAt: self.url)).to(beTrue())
    }
    
    func testShouldRotateWhenFileWillExceedMaxSize() {
        configureFile(exists: true, size: maxSize + 1)
        expect(self.wheel.shouldRotate(fileAt: self.url)).to(beTrue())
    }
    
    func testShouldNotRotateWhenFileWillNotExceedMaxSize() {
        let data = "a".data(using: .utf8)!
        configureFile(exists: true, size: maxSize - UInt64(data.count + 1))
        expect(self.wheel.shouldRotate(fileAt: self.url)).to(beFalse())
    }
    
    func testShouldRotateWhenFileIsEmpty() {
        configureFile(exists: true, size: 0)
        expect(self.wheel.shouldRotate(fileAt: self.url)).to(beFalse())
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
        
        backups.forEach { aURL in
            try? wheel.fileManager.removeItem(at: aURL)
        }
    }
    
    struct Backup: Hashable {
        var url: URL
        var created: Date?
        init(_ aUrl: URL) {
            url = aUrl
            created = aUrl.createdDate
        }
        
        var hashValue: Int { url.hashValue }
        func hash(into hasher: inout Hasher) {
            hasher.combine(url)
        }
    }
    
    func testRotationDeletesOldFile() {
        Array(repeating: 0, count: wheel.maxNumberOfBackups).forEach { _ in
            wheel.fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            try! wheel.backupFile(at: url)
        }
        let backupsBeforeRotation = try! wheel.backupsOfFile(at: url).map { Backup.init($0) }
        expect(backupsBeforeRotation.count) == wheel.maxNumberOfBackups
        
        wheel.fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        try! wheel.backupFile(at: url)
        let backupsAfterRotation: [Backup] = try! wheel.backupsOfFile(at: url).map { Backup.init($0) }
        expect(backupsAfterRotation.count) == wheel.maxNumberOfBackups
        
        let allBackups = Set(backupsBeforeRotation + backupsAfterRotation).sorted { $0.created! < $1.created! }
        let expectedBackups = Array(allBackups.suffix(wheel.maxNumberOfBackups))
        expect(backupsAfterRotation) == expectedBackups
        
        allBackups.forEach { aBackup in
            guard wheel.fileManager.fileExists(atPath: aBackup.url.path) else { return }
            try? wheel.fileManager.removeItem(at: aBackup.url)
        }
    }
    
    // MARK: - Configuring
    
    private func configureFile(exists: Bool, size: UInt64 = 0) {
        stub(wheel) { stub in
            when(stub.fileExists(at: any())).thenReturn(exists)
            if exists {
                when(stub.fileSize(at: any())).thenReturn(size)
            }
        }
    }
}
