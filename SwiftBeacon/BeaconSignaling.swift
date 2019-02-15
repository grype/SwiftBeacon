//
//  BeaconSignaling.swift
//  SwiftBeacon
//
//  Created by Pasha on 1/29/19.
//  Copyright © 2019 Grype. All rights reserved.
//

import Foundation

public protocol BeaconSignaling {
    var beaconSignal: BeaconSignal { get }
}

public func emit(_ value: BeaconSignaling, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(on: beacon,
                            userInfo: userInfo,
                            fileName: fileName,
                            line: line,
                            functionName: functionName)
}
