//
//  SignalStringEncoder.swift
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
    
    open func data(from aSignal: Signal) -> Data? {
        return "\(String(describing: aSignal))\(separator)".data(using: encoding)
    }
}
