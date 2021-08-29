//
//  EncodedStreamSignalWriter.swift
//  
//
//  Created by Pavel Skaldin on 8/26/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I encode `Signals` onto an `OutputStream`
 */

@available(*, message: "mocked")
public class EncodedStreamSignalWriter : SignalWriter {
    
    open var encoder: SignalEncoder
    
    open var stream: OutputStream
    
    open var separator: Data = .init()
    
    // MARK:- Init
    
    public init(on aStream: OutputStream, encoder anEncoder: SignalEncoder) {
        stream = aStream
        encoder = anEncoder
    }
    
    // MARK:- Opening/Closing
    
    open func open() {
        stream.open()
    }
    
    open func close() {
        stream.close()
    }
    
    
    // MARK:- Writing
    
    open func write(_ aSignal: Signal) throws {
        let data = try encoder.encode(aSignal)
        data.write(on: stream)
        separator.write(on: stream)
    }
    
}
