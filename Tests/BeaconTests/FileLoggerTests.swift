//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/18/19.
//

import XCTest

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
}
