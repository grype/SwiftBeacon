//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/18/19.
//

import XCTest
@testable import Beacon

class FileLoggerTests : XCTestCase {
    
    private let fileURL = URL(fileURLWithPath: "/tmp/beacon-test.log")
    
    private var logger: FileLoggerSpy!
    
    override func setUp() {
        super.setUp()
        logger = FileLoggerSpy(url: fileURL, name: "Beacon-Test-File-Logger")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOpeFileOnStart() {
        logger.start()
        assert(logger.invokedOpenFileForWriting, "Starting logger did not attempt to open file for writing")
    }
    
    func testNextPut() {
        removeLogfile()
        logger.start()
        let signal = StringSignal("Hello world")
        logger.nextPut(signal)
        logger.stop()
        let data = try? Data(contentsOf: fileURL)
        assert(data != nil, "Failed to read in log file")
        assert(String(data: data!, encoding: .utf8) == signal.description, "Inconsistent logfile data")
    }
    
    // mark:- Helpers
    
    private func removeLogfile() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            try! fileManager.removeItem(at: fileURL)
        }
    }
    
}
