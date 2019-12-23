//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

open class StringJSONEncoder : SignalStringEncoder {
    public override func encode(_ aSignal: Signal, on aStream: OutputStream) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(aSignal), let str = String(data: data, encoding: encoding) else { return }
        aStream.write(str, maxLength: str.lengthOfBytes(using: encoding))
    }
}
