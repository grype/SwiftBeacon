//
//  SignalWriter.swift
//
//
//  Created by Pavel Skaldin on 8/26/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I define a simple protocol for writing out `Signal`s.

 All I require is a method that takes a signal and writes it out somewhere.
 One concrete example of - `EncodedStreamSignalWriter` which encodes `Signal`s
 and writes them out on to a stream.
 */
public protocol SignalWriter {
    func write(_ aSignal: Signal) throws
}
