//
//  ConsoleLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

/**
 I am a console logger of `Signal`s.
 
 I mimic traditional loggers by simply printing out descriptions of the signals I receive.
 I can also indicate periods of inactivity via `markedInactivityPeriod`.
 */

open class ConsoleLogger: SignalLogger {
    public typealias Input = <#type#>
    
    public typealias Failure = <#type#>
    
    // MARK: - Instance Creation

    public static let shared = ConsoleLogger(name: "Shared Console Logger")
    
    // MARK: - Properties
    
    open private(set) var name: String
    
    /// Period of time since receiving the last signal, after which I am considered idle.
    /// When the value is > 0, I will prefix the next signal with a special `inactivityDelimiter`.
    open var markedInactvitiyPeriod: TimeInterval = 10
    
    open var inactivityDelimiter: String = "⏳"
    
    private var lastPrintDate: Date?
    
    // MARK: - Init
    
    public init(name: String) {
        self.name = name
    }
    
    // MARK: - Subscription
    
    public func receive(completion: Subscribers.Completion<Never>) {
        // Nothing to do
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // MARK: - Logging
    
    public func nextPut(_ signal: [Signal]) throws {
        if markedInactvitiyPeriod > 0, let lastPrintDate = lastPrintDate, Date().timeIntervalSince(lastPrintDate) > markedInactvitiyPeriod {
            print(inactivityDelimiter)
        }
        print("\(signal.debugDescription)")
        lastPrintDate = Date()
    }
}
