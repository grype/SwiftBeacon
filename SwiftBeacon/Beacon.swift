//
//  Beacon.swift
//  SwiftBeacon
//
//  Created by Pasha on 10/20/18.
//  Copyright © 2018 Grype. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let BeaconSignal = Notification.Name(rawValue: "BeaconSignal")
}

class Beacon {
    
    static var shared = Beacon()
    
    // MARK:- Accessing
    
    let announcer = NotificationCenter.default
    
    var loggers = [BeaconSignalLogger]()
    
    // MARK:- Announcements

    func announce(_ signal: BeaconSignal) {
        announcer.post(name: NSNotification.Name.BeaconSignal,
                       object: self,
                       userInfo: ["signal": signal])
    }
}
