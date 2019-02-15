//
//  BeaconConsoleLogger.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

public class BeaconConsoleLogger : BeaconSignalLogger {
    public var markedInactvitiyPeriod: TimeInterval = 10
    private var lastPrintDate: Date?
    
    override public func nextPut(_ aSignal: BeaconSignal) {
        if markedInactvitiyPeriod > 0, let lastPrintDate = lastPrintDate, Date().timeIntervalSince(lastPrintDate) > markedInactvitiyPeriod {
            print("⏳")
        }
        print("\(String(describing: aSignal))")
        lastPrintDate = Date()
    }
}
