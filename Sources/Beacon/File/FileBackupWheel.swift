//
//  FileBackupWheel.swift
//
//
//  Created by Pavel Skaldin on 5/20/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I rotate files that exceed certain file size by keeping a certain number of backups.
 
 I keep backup files in the same directory as the original, suffixing them with a date string. If a backup file already exists, during rotation, an index is appended to the filename.
 
 For example, 'foo.log' will be backed up to 'foo.2021-12-31-23-59-59.log', using default date format. If that file exists, 'foo.2021-12-31-23-59-59.1.log' is tried, and then 'foo.2021-12-31-23-59-59.2.log', and so on until a non-existent path is derived.
 
 Example:
 ```
 let logfile = URL()
 let wheel = FileBackupWheel(maxFileSize: 2*1024*1024, maxNumberOfBackups: 5)
 if wheel.shouldRotate(fileAt: URL(fileURLWithPath: "/tmp/foo.log"))
 ```
 */

open class FileBackupWheel: FileRotation {
    // Max file size, in bytes, that log file should not exceed
    open var maxFileSize: UInt64 = 0
    
    open var maxNumberOfBackups: Int = 0
    
    open var fileManager: FileManager = .default
    
    open var dateFormatter: DateFormatter = .init(format: .fileSortable)
    
    // MARK: - Init
    
    public init(maxFileSize aSize: UInt64, maxNumberOfBackups aCount: Int) {
        maxFileSize = aSize
        maxNumberOfBackups = aCount
    }
    
    // MARK: - Rotating
    
    open func shouldRotate(fileAt url: URL) -> Bool {
        guard fileExists(at: url) else { return false }
        let currentSize = fileSize(at: url)
        return currentSize > 0 && (maxFileSize <= currentSize)
    }
    
    // Rotates file at given URL and returns Bool indicating successful operation
    open func rotate(fileAt aURL: URL) throws {
        try backupFile(at: aURL)
    }
    
    // MARK: - Backing up
    
    open func backupFile(at aURL: URL) throws {
        try deleteOldBackupsOfFile(at: aURL)
        try fileManager.moveItem(at: aURL, to: nextBackupURLFor(url: aURL))
    }
    
    open func deleteOldBackupsOfFile(at aURL: URL) throws {
        guard maxNumberOfBackups > 0 else { return }
        let backups = try backupsOfFile(at: aURL)
        guard backups.count >= maxNumberOfBackups else { return }
        try backups.prefix(maxNumberOfBackups - 1).forEach { aURL in
            try fileManager.removeItem(at: aURL)
        }
    }
    
    open func backupsOfFile(at aURL: URL) throws -> [URL] {
        let prefix = aURL.deletingPathExtension().lastPathComponent + "."
        let dir = aURL.deletingLastPathComponent()
        return try fileManager
            .contentsOfDirectory(atPath: dir.path)
            .filter { aFileName in
                aFileName != aURL.lastPathComponent && aFileName.hasPrefix(prefix)
            }
            .map { dir.appendingPathComponent($0) }
            .sorted {
                guard let a = $0.createdDate, let b = $1.createdDate else { return $0.path < $1.path }
                return a < b
            }
    }
    
    open func nextBackupURLFor(url: URL) -> URL {
        let timestamp = dateFormatter.string(from: Date())
        var suffix = timestamp
        let fileManager = self.fileManager
        let dir = url.deletingLastPathComponent()
        let baseName = url.deletingPathExtension().lastPathComponent
        let ext = url.pathExtension
        var index: UInt8 = 0
        var nextURL: URL!
        
        repeat {
            nextURL = dir.appendingPathComponent("\(baseName).\(suffix).\(ext)")
            index += 1
            suffix = "\(timestamp) (\(index))"
        } while fileManager.fileExists(atPath: nextURL.path)
        
        return nextURL
    }
    
    // MARK: - File (Internal)
    
    open func fileExists(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: (url.path as NSString).resolvingSymlinksInPath)
    }
    
    open func fileSize(at url: URL) -> UInt64 {
        guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path) else { return 0 }
        return (fileAttributes as NSDictionary).fileSize()
    }
}
