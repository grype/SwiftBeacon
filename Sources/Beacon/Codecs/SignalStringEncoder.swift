//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

open class SignalStringEncoder : SignalEncoding {
    
    var encoding : String.Encoding
    
    var separator = "\n"
    
    init(_ anEncoding: String.Encoding) {
        encoding = anEncoding
    }
    
    public func encode(_ aSignal: Signal, on aStream: OutputStream) {
        let text = "\(String(describing: aSignal))\(separator)"
        aStream.write(text, maxLength: text.lengthOfBytes(using: encoding))
    }
}
