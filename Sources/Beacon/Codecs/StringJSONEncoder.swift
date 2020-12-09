//
//  StringJSONEncoder.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
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
