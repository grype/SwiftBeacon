//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation

/**
 I rotate files using a block.
 
 I can be configured to rotate files whenever a logger starts and whenever output file is about to exceed a certain size.
 */
public class FileWheel : FileRotation {
    
    public typealias RotationBlock = (_ url: URL) -> Void
    
    // MARK: - Variables
    
    // Whether or not a new log file should be created when logger is started
    open var rotateOnStart: Bool
    
    // Max file size, in bytes, that log file should not exceed
    open var maxFileSize: UInt64
    
    var rotationBlock: RotationBlock!
    
    // MARK: - Init
    
    init(rotateOnStart onStart: Bool = false, maxFileSize aSize: UInt64 = 10485760, block: @escaping RotationBlock) {
        rotateOnStart = onStart
        maxFileSize = aSize
        rotationBlock = block
    }
    
    // MARK: - Rotation
    
    open func shouldRotate(fileAt url: URL, for event: FileLogger.Event) -> Bool {
        switch event {
        case .start:
            return rotateOnStart
        case .put(let size):
            return fileExists(at: url) && (maxFileSize < (fileSize(at: url) + UInt64(size)))
        }
    }
    
    open func rotate(fileAt url: URL) {
        rotationBlock(url)
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
