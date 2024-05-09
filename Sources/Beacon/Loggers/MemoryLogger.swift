//
//  MemoryLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

/**
 I am memory-based logger of `Signal`s.
 
 I manage an array of signals via `recordings` property, and I keep it to at most `limit` number of signals.
 I am mostly useful for debugging at run time.
 
 */

open class MemoryLogger: SignalLogger {
    // MARK: - Types
    
    public typealias Input = Signal
    
    // MARK: - Instance creation

    public static var shared = MemoryLogger(name: "MemoryLogger")
    
    // MARK: - Properties

    public var name: String
    
    open private(set) var recordings = [Signal]()
    open var limit: Int = 1024
    
    public init(name: String) {
        self.name = name
    }
    
    // MARK: - Receiving
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: Signal) -> Subscribers.Demand {
        nextPut(input)
        return .unlimited
    }
    
    public func receive(completion: Subscribers.Completion<Never>) {
        // Nothing to do
    }
    
    open func nextPut(_ aSignal: Signal) {
        recordings.append(aSignal)
        guard limit > 0, recordings.count - limit > 0 else { return }
        recordings.removeFirst(recordings.count - limit)
    }
    
    open func clear() {
        recordings.removeAll()
    }
}
