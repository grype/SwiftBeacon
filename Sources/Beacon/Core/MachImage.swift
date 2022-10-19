//
//  MachImage.swift
//
//
//  Created by Pavel Skaldin on 5/4/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation
import MachO

#if arch(x86_64) || arch(arm64)
public typealias MachHeader = mach_header_64
#else
public typealias MachHeader = mach_header
#endif

/**
 I capture some information about a MachO binary image that is useful for symbolicating stack traces.
 */
public struct MachImage: Encodable {
    /// Full name of the binary image (this will be a file path)
    public var name: String
    /// Memory address at which the image was loaded
    public var address: Int
    /// The slide value used for loading the image
    public var slide: Int
    /// Architecture of the image
    public var arch: String?
    /// UUID of the image, extracted from LC_UUID load command
    public var uuid: UUID?

    /// Total number of loaded images
    public static var loadedImageCount: UInt32 { _dyld_image_count() }

    public init(at index: UInt32) {
        let header = unsafeBitCast(_dyld_get_image_header(index), to: UnsafePointer<MachHeader>.self)
        name = String(cString: _dyld_get_image_name(index))
        address = Int(bitPattern: header)
        slide = _dyld_get_image_vmaddr_slide(index)
        if let cpuType = NXGetArchInfoFromCpuType(header.pointee.cputype, header.pointee.cpusubtype) {
            arch = String(cString: cpuType.pointee.name)
        }

        var cursor = UnsafeRawPointer(header.advanced(by: 1))
        for _ in 0 ..< header.pointee.ncmds {
            let command = cursor.bindMemory(to: load_command.self, capacity: 1)
            if command.pointee.cmd == LC_UUID {
                uuid = UUID(uuid: cursor.bindMemory(to: uuid_command.self, capacity: 1).pointee.uuid)
            }
            cursor = cursor.advanced(by: Int(command.pointee.cmdsize))
        }
    }
}

// MARK: - CustomStringConvertible

extension MachImage: CustomStringConvertible {
    public var description: String {
        return "<0x\(String(format: "%02X", address))+\(slide)> [\(arch ?? "?")] \(uuid?.uuidString ?? "") \(name)"
    }
}
