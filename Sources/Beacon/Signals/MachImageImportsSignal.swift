//
//  MachImageImportsSignal.swift
//
//
//  Created by Pavel Skaldin on 5/7/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures currently loaded Mach images
 */

open class MachImageImportsSignal: Signal {
    var added: [MachImage]?
    
    var removed: [MachImage]?
    
    override open class var portableClassName: String? { "RemoteImportsSignal" }
    
    // MARK: - Signal
    
    override open var signalName: String { "🧩" }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case added, removed
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(added, forKey: .added)
        try container.encodeIfPresent(removed, forKey: .removed)
    }
    
    // MARK: - Describing
    
    override open var valueDescription: String? {
        var lines = [String]()
        if let added = added {
            lines.append("Images Added: \(added)")
        }
        if let removed = removed {
            lines.append("Images Removed: \(removed)")
        }
        return lines.joined(separator: "\n")
    }
}
