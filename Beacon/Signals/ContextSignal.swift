//
//  FunctionCallSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2018 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `Signal` that captures current context.
 
 I am used for announcing a particular point in the code. Simply call `emit()`, without
 any arguments...
 */
public class ContextSignal: Signal {
    @objc public var stack: [String]
    
    @objc public init(stack aStack: [String] = Thread.callStackSymbols) {
        stack = aStack
        super.init()
    }

    public override var signalName: String {
        return "🌀 \(super.signalName)"
    }
    
    public override class var portableClassName : String? {
        return "RemoteContextStackSignal"
    }
    
    private enum CodingKeys : String, CodingKey {
        case stack
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stack.map { CallStackSymbol.fromString($0) }, forKey: .stack)
    }
    
    public override var description: String {
        var result = "\(super.description)"
        stack.forEach { result.append(contentsOf: "\n\t\($0)") }
        return result
    }
}

/// Signal current context
public func emit(on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

/// Signal current context
public func emit(on beacons: [Beacon], userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    ContextSignal().emit(on: beacons, userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}

struct CallStackSymbol : Encodable, CustomStringConvertible {
    var index: Int
    var module: String
    var address: Int
    var invocation: String
    
    static func fromString(_ aString: String) -> CallStackSymbol {
        let parts = aString.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        let index = Int(parts[0])!
        let address = Int(parts[2].suffix(from: parts[2].index(parts[2].startIndex, offsetBy: 2)), radix: 16)!
        return CallStackSymbol(index: index, module: parts[1], address: address, invocation: Array(parts[3..<parts.count]).joined(separator: " "))
    }
    
    private enum CodingKeys : String, CodingKey {
        case index, module, address, invocation
    }
    
    var description: String {
        return "\(index) \(module) \(String(format: "%02x", address)) \(invocation)"
    }
}
