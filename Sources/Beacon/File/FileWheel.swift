//
//  FileWheel.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I rotate files using a block.
 */
public class FileWheel : FileRotation {
    
    public typealias RotationBlock = (_ url: URL) -> Bool
    
    // MARK: - Variables
    
    // Max file size, in bytes, that log file should not exceed
    open var maxFileSize: UInt64
    
    // Block should perform log rotation and reutrn Bool value indicating whether the file was rotated.
    var rotationBlock: RotationBlock!
    
    // MARK: - Init
    
    init(maxFileSize aSize: UInt64, block: @escaping RotationBlock) {
        maxFileSize = aSize
        rotationBlock = block
    }
    
    // MARK: - Rotation
    
    open func shouldRotate(fileAt url: URL, for data: Data) -> Bool {
        guard data.count > 0 else { return false }
        guard fileExists(at: url) else { return false }
        let currentSize = fileSize(at: url)
        return currentSize > 0 && (maxFileSize < (currentSize + UInt64(data.count)))
    }
    
    open func rotate(fileAt url: URL) -> Bool {
        return rotationBlock(url)
    }
    
    // MARK:- File (Internal)
    
    func fileExists(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: (url.path as NSString).resolvingSymlinksInPath)
    }
    
    func fileSize(at url: URL) -> UInt64 {
        guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path) else { return 0 }
        return (fileAttributes as NSDictionary).fileSize()
    }
}
