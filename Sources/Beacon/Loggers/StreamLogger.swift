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

open class StreamLogger: SignalLogger {
    // MARK: - Properties
    
    private(set) var writer: EncodedStreamSignalWriter
    
    // MARK: - Instance Creation
    
    public class func starting<T: StreamLogger>(name aName: String, writer aWriter: EncodedStreamSignalWriter, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
        let me = self.init(name: aName, writer: aWriter)
        me.subscribe(to: beacons, filter: filter)
        return me as! T
    }
    
    override open class func starting<T>(name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: SignalLogger.Filter? = nil) -> T where T: SignalLogger {
        fatalError("Use StreamLogger.starting(name:writer:on:filter:)")
    }
    
    // MARK: - Init
    
    public required init(name aName: String, writer aWriter: EncodedStreamSignalWriter) {
        writer = aWriter
        super.init(name: aName)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Instantiate with init(name:on:)")
    }
    
    // MARK: - Starting/Stopping
    
    override func didStart(on beacons: [Beacon]) {
        super.didStart(on: beacons)
        writer.open()
    }
    
    override func didStop() {
        super.didStop()
        writer.close()
    }
    
    // MARK: - Logging
    
    override open func nextPut(_ aSignal: Signal) {
        do {
            try writer.write(aSignal)
        }
        catch {
            print("Error writing signal: \(error)")
        }
    }
}
