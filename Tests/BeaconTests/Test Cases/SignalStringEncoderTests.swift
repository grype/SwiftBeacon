//
//  SignalStringEncoderTests.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
@testable import Beacon

class SignalStringEncoderTests : XCTestCase {
    
    func testEncode() {
        let count = 10
        let signals = (0..<count).map { StringSignal("Signal \($0)") }
        let stream = OutputStream.toMemory()
        stream.open()
        
        let encoder = SignalStringEncoder(.utf8)
        encoder.separator = "🔅"
        var data = encoder.data(from: signals.first!)!
        let _ = data.write(on: stream)
        
        var output = contents(of: stream, encoding: encoder.encoding)
        
        XCTAssertEqual(output, "\(signals.first!.description)\(encoder.separator)", "First signal encoded incorrectly")

        (1..<count).forEach { (i) in
            data = encoder.data(from: signals[i])!
            let _ = data.write(on: stream)
        }

        output = contents(of: stream, encoding: encoder.encoding)
        XCTAssertEqual(output, signals.map { "\($0.description)\(encoder.separator)" }.joined(), "Multiple signals encoded incorrectly")
        print(contents)
        
        stream.close()
    }
    
    private func contents(of aStream: OutputStream, encoding: String.Encoding) -> String?  {
        guard let data = aStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else { return nil }
        return String(data: data, encoding: encoding)
    }
    
}
