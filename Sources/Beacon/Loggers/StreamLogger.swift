//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/20/19.
//

import Foundation

/**
 I am a logger that logs signals onto an OutputStream.
 
 I get instantiated with an output stream and an encoder.
 When I am started, I open the stream and write out emitted signals
 onto that stream by using an encoder. The encoder is what's
 going to be doing the actual writing onto the stream.
 
 Example:
 let logger = StreamLogger(name: "Example", on: URL(fileURLWithPath: "/tmp/example.log"), encoder: SignalStringEncoder(.utf8))
 logger.nextPut(StringSignal("Hello world"))
 */

open class StreamLogger : SignalLogger {
    
    // MARK: - Variables
    
    private(set) var url: URL?
    
    var stream: OutputStream
    
    var encoder: SignalEncoding
    
    // MARK: - Init
    
    @objc(initWithName:onStream:encoder:)
    public required init(name aName: String, on aStream: OutputStream, encoder anEncoder: SignalEncoding) {
        stream = aStream
        encoder = anEncoder
        super.init(name: aName)
    }
    
    @objc(initWithName:onURL:encoder:)
    public convenience init(name aName: String, on anUrl: URL, encoder: SignalEncoding) {
        self.init(name: aName, on: OutputStream(url: anUrl, append: true)!, encoder: encoder)
        url = anUrl
    }
    
    @objc public required init(name aName: String) {
        fatalError("Instantiate with init(name:on:)")
    }
    
    // MARK: - Starting/Stopping
    
    override func didStart() {
        super.didStart()
        if let url = url {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: url.path) {
                fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
        }
        stream.open()
    }
    
    override func didStop() {
        super.didStop()
        stream.close()
    }
    
    // MARK: - Logging
    
    override open func nextPut(_ aSignal: Signal) {
        encoder.encode(aSignal, on: stream)
    }
    
}
