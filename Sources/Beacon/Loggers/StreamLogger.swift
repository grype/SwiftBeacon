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
    
    // MARK: - Properties
    
    var stream: OutputStream
    
    var encoder: SignalEncoding
    
    // MARK: - Instance Creation
    
    public class func starting<T:StreamLogger>(name aName: String, stream aStream: OutputStream, encoder anEncoder: SignalEncoding, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
        let me = self.init(name: aName, on: aStream, encoder: anEncoder)
        me.subscribe(to: beacons, filter: filter)
        return me as! T
    }
    
    override open class func starting<T>(name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: SignalLogger.Filter? = nil) -> T where T : SignalLogger {
        fatalError("Use StreamLogger.starting(name:stream:encoder:on:filter:)")
    }
    
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
        do {
            try write(data: data)
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    func write(data: Data) throws {
        let _ = data.write(on: stream)
    }
    
}
