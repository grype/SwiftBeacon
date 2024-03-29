//
//  MemoryLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import RWLock

/**
 I am memory-based logger of `Signal`s.
 
 I manage an array of signals via `recordings` property, and I keep it to at most `limit` number of signals.
 I am mostly useful for debugging at run time.
 
 */

open class MemoryLogger: SignalLogger {
    @objc public static var shared = MemoryLogger(name: "MemoryLogger")
    
    @objc @RWLocked open private(set) var recordings = [Signal]()
    @objc open var limit: Int = 100
    
    override open func nextPut(_ aSignal: Signal) {
        recordings.append(aSignal)
        guard limit > 0, recordings.count - limit > 0 else { return }
        recordings.removeFirst(recordings.count - limit)
    }
    
    @objc open func clear() {
        recordings.removeAll()
    }
}
