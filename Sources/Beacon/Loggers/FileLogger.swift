//
//  FileLogger.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I log signals to a file, using their description.
 
 I am based on StreamLogger and provide additional mechanisms that are useful for managing files.
 One such mechanism is support for file rotation.
 */

open class FileLogger : StreamLogger {
    
    open private(set) var url: URL?
    
    // Whether to rotate log file when starting.
    // This would only make sense if `wheel` is set.
    open var rotateOnStart = false
    
    // Optional object responsible for log rotation.
    // When provided, it will be given a change to rotate
    // current log file at two stages: when the logger is
    // started, if `rotateOnStart` is true; and before
    // writing data into the curernt log file.
    open var wheel: FileRotation?
    
    public required init(name aName: String, on anUrl: URL, encoder anEncoder: SignalEncoding) {
        url = anUrl
        super.init(name: aName, on: OutputStream(url: anUrl, append: true)!, encoder: anEncoder)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Use init(name:on:encoder:) to instantiate")
    }
    
    public required init(name aName: String, on aStream: OutputStream, encoder anEncoder: SignalEncoding) {
        fatalError("Use init(name:on:encoder:) with URL instead of OutputStream")
    }
    
    override func didStart() {
        if rotateOnStart, let url = url, let wheel = wheel {
            let _ = wheel.rotate(fileAt: url)
            
        }
        super.didStart()
    }
    
    override func write(data: Data) {
        defer { super.write(data: data) }
        guard let url = url, let wheel = wheel, wheel.shouldRotate(fileAt: url, for: data) else { return }
        forceRotate()
    }
    
    @discardableResult
    open func forceRotate() -> Bool {
        guard let wheel = wheel, let url = url else { return false }
        stream.close()
        let didRotate = wheel.rotate(fileAt: url)
        if didRotate {
            stream = OutputStream(url: url, append: true)!
        }
        stream.open()
        return didRotate
    }
    
}
