//
//  SignalDescriptionEncoder.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I encode Signals using their description property.
 */

open class SignalDescriptionEncoder : SignalEncoder {

    public enum Errors : String, Error {
        case encoding = "Failed to encode signal"
    }
    
    open var encoding : String.Encoding
    
    public init(encoding anEncoding: String.Encoding = .utf8) {
        encoding = anEncoding
    }
    
    public func encode(_ aSignal: Signal) throws -> Data {
        guard let data = aSignal.debugDescription.data(using: encoding) else {
            throw Errors.encoding
        }
        return data
    }
}
