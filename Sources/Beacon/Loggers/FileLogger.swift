//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/17/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
I am a file logger of `Signal`s.

I am similar to a `ConsoleLogger` and print received signals to a file.
Don't use multiple instances of me on the same file - bad things may happen.
*/

open class FileLogger : SignalLogger {
    
    /// File URL where signals are written to
    @objc open private(set) var url: URL!
    
    private var fileHandle: FileHandle?
    
    @objc required public init(url anUrl: URL, name: String) {
        url = anUrl
        super.init(name: name)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Use init(url:name:) to instantiate")
    }
    
    override open func nextPut(_ aSignal: Signal) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard let data = String(describing: aSignal).data(using: .utf8) else { return }
        fileHandle?.write(data)
    }
    
    override open func didStart() {
        super.didStart()
        openFileForWriting()
    }
    
    override open func didStop() {
        super.didStop()
        closeFile()
    }
    
    // mark:- File handling
    
    internal func openFileForWriting() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard fileHandle == nil else { return }
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        fileHandle = try! FileHandle(forWritingTo: url)
        fileHandle?.seekToEndOfFile()
    }
    
    internal func closeFile() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        fileHandle?.closeFile()
    }
}
