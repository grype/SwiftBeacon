//
//  JSONSignalEncoder.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
I encode Signals by trying to represent them in JSON notation.
*/

@available(*, message: "mocked")
open class JSONSignalEncoder : SignalEncoder {
    
    open lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.init(format: .iso8601))
        return encoder
    }()
    
    public func encode(_ aSignal: Signal) throws -> Data {
        return try encoder.encode(aSignal)
    }
    
    public init() {
    }
    
}
