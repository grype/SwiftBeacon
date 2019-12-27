//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
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
        encoder.encode(signals.first!, on: stream)
        
        var output = contents(of: stream, encoding: encoder.encoding)
        
        XCTAssertEqual(output, "\(signals.first!.description)\(encoder.separator)", "First signal encoded incorrectly")

        (1..<count).forEach { (i) in
            encoder.encode(signals[i], on: stream)
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
