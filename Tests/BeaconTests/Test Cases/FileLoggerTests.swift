//
//  FileLoggerTests.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon

class FileLoggerTests : XCTestCase {
    
    private var logger: FileLogger!
    
    private let url = URL(fileURLWithPath: "/tmp/FileLoggerTests.log")
    
    private var rotationCount = 0
    
    private let signal = StringSignal("I will force log file to overgrow")
    
    override func setUp() {
        super.setUp()
        initLogFile()
        let wheel = FileWheel(maxFileSize: UInt64(10)) { (url) -> Bool in
            self.rotationCount += 1
            return true
        }
        logger = FileLogger(name: "FileLoggerTests", on: url, encoder: SignalStringEncoder(.utf8))
        logger.wheel = wheel
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
        logger = nil
    }
    
    func testLogRotation() {
        logger.start()
        logger.nextPut(signal)
        XCTAssertEqual(rotationCount, 0, "Shouldn't have rotated empty file, so as to prevent accidental rotation cycle")
        
        logger.nextPut(signal)
        XCTAssertEqual(rotationCount, 1, "Should have rotated file before writing out data that would exceed max configured size")
        
        logger.nextPut(signal)
        XCTAssertEqual(rotationCount, 2, "Should have rotated file once more before writing out data that would exceed max configured size")
        
        let content = logContents()
        XCTAssertNotNil(content, "Should have produced some content")
        
        XCTAssertEqual(content, [signal, signal, signal].reduce("", { (string, signal) -> String in
            let separator = (logger.encoder as! SignalStringEncoder).separator
            return "\(string)\(signal.description)\(separator)"
        }))
    }
    
    func testLogRotationOnStart() {
        logger.rotateOnStart = true
        logger.start()
        XCTAssertEqual(rotationCount, 1, "Should have rotated logfile on start")
    }
    
    private func initLogFile() {
        removeLogFile()
        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
    
    private func removeLogFile() {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: url.path) else { return }
        try! fileManager.removeItem(at: url)
    }
    
    private func logContents() -> String? {
        return try! String(contentsOf: url)
    }
    
}
