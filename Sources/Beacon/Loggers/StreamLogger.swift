//
//  StreamLogger.swift
//
//
//  Created by Pavel Skaldin on 12/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
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
    public typealias Input = Signal
    
    public typealias Failure = Error
    
    // MARK: - Properties
    
    public private(set) var name: String
    
    public private(set) var writer: EncodedStreamSignalWriter
    
    // MARK: - Init
    
    public required init(name aName: String, stream aStream: OutputStream, encoder anEncoder: SignalEncoder) {
        name = aName
        writer = EncodedStreamSignalWriter(on: aStream, encoder: anEncoder)
    }
    
    public required init(name aName: String, writer aWriter: EncodedStreamSignalWriter) {
        name = aName
        writer = aWriter
    }
    
    // MARK: - Receiving
    
    public func receive(subscription: Subscription) {
        writer.open()
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: Signal) -> Subscribers.Demand {
        do {
            try nextPut(input)
        }
        catch {
            print("Error: \(error)")
            return .none
        }
        return .unlimited
    }

    public func receive(completion: Subscribers.Completion<Failure>) {
        writer.close()
    }

    // MARK: - Logging
    
    open func nextPut(_ aSignal: Signal) throws {
        try writer.write(aSignal)
    }
}
