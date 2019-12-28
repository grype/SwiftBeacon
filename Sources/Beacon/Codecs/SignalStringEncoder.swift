//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

/**
 I encode Signals using their description property.
 */

open class SignalStringEncoder : SignalEncoding {
    
    var encoding : String.Encoding
    
    var separator = "\n"
    
    init(_ anEncoding: String.Encoding) {
        encoding = anEncoding
    }
    
    open func encode(_ aSignal: Signal, on aStream: OutputStream) {
        let text = "\(String(describing: aSignal))\(separator)"
        aStream.write(text, maxLength: text.lengthOfBytes(using: encoding))
    }
    
    open func encodedSize(of aSignal: Signal) -> Int {
        return aSignal.description.maximumLengthOfBytes(using: encoding)
    }
}
