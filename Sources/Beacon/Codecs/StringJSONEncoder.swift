//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

/**
I encode Signals by trying to represent them in JSON notation.
*/

open class StringJSONEncoder : SignalStringEncoder {
    
    let encoder = JSONEncoder()
    
    open override func encode(_ aSignal: Signal, on aStream: OutputStream) {
        guard let json = json(for: aSignal) else { return }
        aStream.write(json, maxLength: json.lengthOfBytes(using: encoding))
    }
    
    open override func encodedSize(of aSignal: Signal) -> Int {
        guard let json = json(for: aSignal) else { return 0 }
        return json.maximumLengthOfBytes(using: encoding)
    }
    
    private func json(for aSignal: Signal) -> String? {
        guard let data = try? encoder.encode(aSignal) else { return nil }
        return String(data: data, encoding: encoding)
    }
    
}
