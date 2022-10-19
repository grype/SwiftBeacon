//
//  SignalEncoder.swift
//
//
//  Created by Pavel Skaldin on 12/23/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I represent a protocol of encoding Signals.

 My implementors are objects that encode Signals onto a stream as a means of logging them.
 */

public protocol SignalEncoder {
    func encode(_ aSignal: Signal) throws -> Data
}
