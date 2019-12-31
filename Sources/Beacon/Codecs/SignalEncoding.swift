//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

/**
 I represent a protocol of encoding Signals.
 
 My implementors are objects that encode Signals onto a stream as a means of logging them.
 */

@objc public protocol SignalEncoding {
    func data(from aSignal: Signal) -> Data?
}
