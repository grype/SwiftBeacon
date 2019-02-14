//
//  BeaconSignaling.swift
//  SwiftBeacon
//
//  Created by Pasha on 1/29/19.
//  Copyright © 2019 Grype. All rights reserved.
//

import Foundation

protocol BeaconSignaling {
    var beaconSignal: BeaconSignal { get }
}

func emit(_ value: BeaconSignaling, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    value.beaconSignal.emit(userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
