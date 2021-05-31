//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 5/7/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation
import MachO
import System

#if canImport(UIKit)
import UIKit
#endif

public struct SystemInfo : Encodable, CustomStringConvertible {
    var name: String?
    var model: String?
    var arch: String?
    
    public static var current: SystemInfo = {
        let info = NXGetLocalArchInfo()
        let arch = String(utf8String: (info?.pointee.description)!)!
        
        #if os(macOS)
        let processInfo = ProcessInfo.processInfo
        let model = sysctlString(for: "hw.model")
        return SystemInfo(name: processInfo.operatingSystemVersionString, model: model, arch: arch)
        #elseif canImport(UIKit)
        let device = UIDevice.current
        let model = sysctlString(for: "hw.machine")
        return SystemInfo(name: "\(device.systemName) \(device.systemVersion)", model: model, arch: arch)
        #else
        return SystemInfo()
        #endif
    }()
    
    public var description: String {
        var result = [name, model, arch].compactMap { $0 }.joined(separator: "; ")
        if result.isEmpty {
            result = "Unknown"
        }
        return result
    }
    
    private static func sysctlString(for key: String) -> String {
        var size = 0
        sysctlbyname(key, nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname(key, &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
