//
//  SignalStringEncoder.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I encode Signals using their description property.
 */

open class SignalStringEncoder : SignalEncoding {
    
    var encoding : String.Encoding
    
    var separator = "\n"
    
    public init(_ anEncoding: String.Encoding) {
        encoding = anEncoding
    }
    
    open func data(from aSignal: Signal) -> Data? {
        return "\(aSignal.debugDescription)\(separator)".data(using: encoding)
    }
}
