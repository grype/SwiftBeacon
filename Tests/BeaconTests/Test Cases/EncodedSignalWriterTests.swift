//
//  EncodedSignalWriterTests.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Cuckoo
import Nimble
@testable import Beacon

class EncodedSignalWriterTests : XCTestCase {
    
    private var writer: MockEncodedStreamSignalWriter!
    
    private var stream: OutputStream { writer.stream }
    
    private var encoder: SignalDescriptionEncoder { writer.encoder as! SignalDescriptionEncoder }
    
    // MARK:- Utilities
    
    private func contents(of aStream: OutputStream, encoding: String.Encoding) -> Data?  {
        return aStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data
    }
    
    // MARK:- Tests
    
    override func setUp() {
        super.setUp()
        writer = MockEncodedStreamSignalWriter(on: OutputStream.toMemory(), encoder: SignalDescriptionEncoder(encoding: .utf8))
        writer.separator = "\n".data(using: .utf8)
    }
    
    func testEncode() {
        let signal = ContextSignal()
        try! writer.write(signal)
        let output = contents(of: writer.stream, encoding: encoder.encoding)
        var expectedOutput = try! encoder.encode(signal)
        expectedOutput.append(writer.separator!)
        expect(output).to(equal(expectedOutput))
        stream.close()
    }
    
}
