//
//  Notification+BeaconSignal.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

extension Notification {
    public var beaconSignal: BeaconSignal? {
        guard let userInfo = userInfo as? [String: BeaconSignal] else { return nil }
        return userInfo[Beacon.SignalUserInfoKey]
    }
}
