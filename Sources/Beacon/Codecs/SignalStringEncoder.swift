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

open class SignalStringEncoder : SignalEncoder {

    enum Errors : String, Error {
        case unknown = "Unknown error"
    }
    
    var encoding : String.Encoding
    
    var separator = "\n"
    
    public init(encoding anEncoding: String.Encoding) {
        encoding = anEncoding
    }
    
    public func encode<T>(_ value: T) throws -> Data where T : Encodable {
        var encoded: String
        if let describable = value as? CustomDebugStringConvertible {
            encoded = "\(describable.debugDescription)\(separator)"
        }
        else if let describable = value as? CustomStringConvertible {
            encoded = "\(describable.description)\(separator)"
        }
        else {
            encoded = "\(String(describing: value))\(separator)"
        }
        guard let data = encoded.data(using: encoding) else {
            throw Errors.unknown
        }
        return data
    }
}
