//
//  Constraints+Sugar.swift
//
//
//  Created by Pavel Skaldin on 3/25/23.
//

import Foundation

prefix operator +
public prefix func +(_ aSignalType: Signal.Type) -> Constraint {
    Constraint(signalType: aSignalType, state: .enabled)
}

prefix operator -
public prefix func -(_ aSignalType: Signal.Type) -> Constraint {
    Constraint(signalType: aSignalType, state: .disabled)
}

infix operator ~>
public extension Constraint {
    static func ~>(lhs: Constraint, rhs: SignalLogger) -> Constraint {
        Constraint(signalType: lhs.signalType, state: lhs.state, logger: rhs)
    }

    static func ~>(lhs: Constraint, rhs: Beacon) -> Constraint {
        Constraint(signalType: lhs.signalType, state: lhs.state, beacon: rhs)
    }

    static func ~>(lhs: Constraint, rhs: (SignalLogger, Beacon)) -> Constraint {
        Constraint(signalType: lhs.signalType, state: lhs.state, logger: rhs.0, beacon: rhs.1)
    }
}
