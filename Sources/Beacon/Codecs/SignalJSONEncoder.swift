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
    
    /// Formatter for encoding dates. This will be passed to the `Signal` before encoding it.
    @objc open lazy var dateFormatter: DateFormatter = .init(format: .iso8601)
    
    open lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    open override func encode(_ aSignal: Signal) -> Data? {
        do {
            return try encoder.encode(aSignal)
        }
        catch {
            print("Encoding error: \(error)")
        }
        return nil
    }
    
}
