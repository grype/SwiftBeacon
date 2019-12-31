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
    
    open override func data(from aSignal: Signal) -> Data? {
        return try? encoder.encode(aSignal)
    }
    
}
