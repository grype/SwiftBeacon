//
//  FunctionCallSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/25/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import MachO

//struct DyldImageInfo : Codable {
//    var name: String
//    var address: Int
//    var slide: Int
//}
//
//func _dyld_image_info(at index: UInt32) -> DyldImageInfo {
//    return DyldImageInfo(name: String(cString: _dyld_get_image_name(index)), address: Int(bitPattern: _dyld_get_image_header(index)), slide: _dyld_get_image_vmaddr_slide(index))
//}

/**
 I am a `Signal` that captures current context.
 
 I am used for announcing a particular point in the code. Simply call `emit()`, without
 any arguments...
 */
open class ContextSignal: Signal {
    
    @objc open var stack: [String]
    
    @objc open var symbols: [String : [Int]]
    
    @objc public init(stack aStack: [String] = Thread.callStackSymbols) {
        stack = aStack
//        imageInfo = (1..<_dyld_image_count()).map { _dyld_image_info(at: $0)}
        symbols = [String: [Int]]()
        for i in 0..<_dyld_image_count() {
            let name = String(cString: _dyld_get_image_name(i))
            let header = Int(bitPattern: _dyld_get_image_header(i))
            let slide = _dyld_get_image_vmaddr_slide(i)
            symbols[name] = [header, slide]
        }
        super.init()
    }

    open override var signalName: String {
        return "🌀 \(super.signalName)"
    }
    
    open override class var portableClassName : String? {
        return "RemoteContextStackSignal"
    }
    
    private enum CodingKeys : String, CodingKey {
        case stack, symbols
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stack.map { CallStackFrame.fromString($0) }, forKey: .stack)
        try container.encode(symbols, forKey: .symbols)
    }
    
    open override var debugDescription: String {
        var result = super.debugDescription
        result += "\nStack:"
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
