//
//  SignalJSONEncoder.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
I encode Signals by trying to represent them in JSON notation.
*/

open class SignalJSONEncoder : SignalStringEncoder {
    
    let encoder = JSONEncoder()
    
    open override func data(from aSignal: Signal) -> Data? {
        var result = try? encoder.encode(aSignal)
        result?.append(separator.data(using: encoding)!)
        return result
    }
    
}
