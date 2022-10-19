//
//  CallStackFrame.swift
//  Beacon
//
//  Created by Pavel Skaldin on 3/7/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

struct CallStackFrame: Encodable, CustomStringConvertible {
    var index: Int
    var module: String
    var address: Int
    var invocation: String

    static func fromString(_ aString: String) -> CallStackFrame {
        let parts = aString.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        let index = Int(parts[0])!
        let address = Int(parts[2].suffix(from: parts[2].index(parts[2].startIndex, offsetBy: 2)), radix: 16)!
        return CallStackFrame(index: index, module: parts[1], address: address, invocation: Array(parts[3 ..< parts.count]).joined(separator: " "))
    }

    private enum CodingKeys: String, CodingKey {
        case index, module, address, invocation
    }

    var description: String {
        return "\(index) \(module) \(String(format: "%02x", address)) \(invocation)"
    }
}
