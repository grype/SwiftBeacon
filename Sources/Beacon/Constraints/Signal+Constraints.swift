//
//  Signal+Constraints.swift
//
//
//  Created by Pavel Skaldin on 3/25/23.
//  Copyright © 2023 Pavel Skaldin. All rights reserved.
//

import Foundation

extension Signal {
    @objc static func enable(constrainedTo aLogger: SignalLogger? = nil, on aBeacon: Beacon? = nil) {
        Constraint.activate {
            Constraint(signalType: self, state: .enabled, logger: aLogger, beacon: aBeacon)
        }
    }

    @objc static func disable(constrainedTo aLogger: SignalLogger? = nil, on aBeacon: Beacon? = nil) {
        Constraint.activate {
            Constraint(signalType: self, state: .disabled, logger: aLogger, beacon: aBeacon)
        }
    }
}
