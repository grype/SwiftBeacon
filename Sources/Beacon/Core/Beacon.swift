//
//  Beacon.swift
//
//
//  Created by Pavel Skaldin on 5/3/24.
//

import Combine
import Foundation

public var Beacon: PassthroughSubject<Signal, Never> = .init()

var OriginalModuleBeacon: PassthroughSubject<Signal, Never> = Beacon
