//
//  Term+Filtering.swift
//
//
//  Created by Pavel Skaldin on 12/1/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import LogicKit

/**
 Convenience creators of specialized `Term`s.
 */
extension Term {
    /// Used to match any beacon or logger object.
    static let any: Term = "any"

    /// Term that captures a specific type of a signal.
    static func signal(_ a: Signal.Type) -> Term { .lit(NSStringFromClass(a)) }

    /// Term that captures enabled/disabled state of a signal type.
    static func signalState(_ a: Constraint.State) -> Term { .lit(a.rawValue) }

    /// Term that captures a given logger object.
    static func logger(_ aLogger: SignalLogger? = nil) -> Term {
        guard let aLogger else { return .any }
        return .val(aLogger)
    }

    /// Term that captures a given beacon object.
    static func beacon(_ aBeacon: Beacon? = nil) -> Term {
        guard let aBeacon else { return .any }
        return .val(aBeacon)
    }
}
