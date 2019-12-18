//
//  ConsoleLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a console logger of `Signal`s.
 
 I mimic traditional loggers by simply printing out descriptions of the signals I receive.
 I can also indicate periods of inactivity via `markedInactivityPeriod`.
 */
open class ConsoleLogger : SignalLogger {
    @objc public static let shared = ConsoleLogger(name: "Shared Console Logger")
    /// Period of time since receiving the last signal, after which I am considered idle.
    /// When the value is > 0, I will prefix the next signal with a special `inactivityDelimiter`.
    @objc open var markedInactvitiyPeriod: TimeInterval = 10
    @objc open var inactivityDelimiter: String = "⏳"
    @objc private var lastPrintDate: Date?
    
    override open func nextPut(_ aSignal: Signal) {
        if markedInactvitiyPeriod > 0, let lastPrintDate = lastPrintDate, Date().timeIntervalSince(lastPrintDate) > markedInactvitiyPeriod {
            print(inactivityDelimiter)
        }
        print("\(String(describing: aSignal))")
        lastPrintDate = Date()
    }
}
