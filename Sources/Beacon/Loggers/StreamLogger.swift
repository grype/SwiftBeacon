//
//  StreamLogger.swift
//  
//
//  Created by Pavel Skaldin on 12/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
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
    
    var stream: OutputStream
    
    var encoder: SignalEncoding
    
    // MARK: - Init
    
    public required init(name aName: String, on aStream: OutputStream, encoder anEncoder: SignalEncoding) {
        stream = aStream
        encoder = anEncoder
        super.init(name: aName)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Instantiate with init(name:on:)")
    }
    
    // MARK: - Starting/Stopping
    
    override func didStart() {
        super.didStart()
        stream.open()
    }
    
    override func didStop() {
        super.didStop()
        stream.close()
    }
    
    // MARK: - Logging
    
    override open func nextPut(_ aSignal: Signal) {
        guard let data = encoder.data(from: aSignal) else { return }
        write(data: data)
    }
    
    func write(data: Data) {
        let _ = data.write(on: stream)
    }
    
}
