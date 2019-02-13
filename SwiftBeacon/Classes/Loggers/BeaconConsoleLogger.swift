//
//  BeaconConsoleLogger.swift
//  Tweed-iOS
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

class BeaconConsoleLogger : BeaconSignalLogger {
    var markedInactvitiyPeriod: TimeInterval = 10
    private var lastPrintDate: Date?
    
    override func nextPut(_ aSignal: BeaconSignal) {
        if markedInactvitiyPeriod > 0, let lastPrintDate = lastPrintDate, Date().timeIntervalSince(lastPrintDate) > markedInactvitiyPeriod {
            print("⏳")
        }
        print("\(String(describing: aSignal))")
        lastPrintDate = Date()
    }
}
