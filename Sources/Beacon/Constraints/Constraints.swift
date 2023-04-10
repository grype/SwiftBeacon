//
//  Constraints.swift
//
//
//  Created by Pavel Skaldin on 3/22/23.
//  Copyright © 2023 Pavel Skaldin. All rights reserved.
//

import Foundation
import LogicKit
import LogicKitBuiltins
import RWLock

// MARK: - Constraint

public struct Constraint {
    // MARK: Types

    public enum State: String, Hashable {
        case enabled, disabled
        var inverse: State { self == .enabled ? .disabled : .enabled }
    }

    // MARK: Properties

    public var signalType: Signal.Type
    public var state: State
    public var logger: SignalLogger?
    public var beacon: Beacon?

    // MARK: Converting

    var term: Term {
        constraint(.signal(signalType), .signalState(state), loggerTerm, beaconTerm)
    }

    var inverseTerm: Term {
        constraint(.signal(signalType), .signalState(state.inverse), loggerTerm, beaconTerm)
    }

    var loggerTerm: Term {
        guard let logger else { return .any }
        return .logger(logger)
    }

    var beaconTerm: Term {
        guard let beacon else { return .any }
        return .beacon(beacon)
    }

    // MARK: Building

    public static func activate(@ConstraintBuilder values: () -> [Constraint]) {
        constraintLock.writeProtected {
            values().forEach { aConstraint in
                constraints.removeAll { $0 == aConstraint.inverseTerm }
                constraints.append(aConstraint.term)
            }
        }
    }

    public static func clearAndActivate(@ConstraintBuilder values: () -> [Constraint]) {
        constraintLock.writeProtected {
            constraints.removeAll()
            values().forEach { aConstraint in
                constraints.removeAll { $0 == aConstraint.inverseTerm }
                constraints.append(aConstraint.term)
            }
        }
    }

    public static func deactivate(@ConstraintBuilder values: () -> [Constraint]) {
        constraintLock.writeProtected {
            values().forEach { aConstraint in
                constraints.removeAll { $0 == aConstraint.term }
            }
        }
    }

    public static func enableAllSignals() {
        constraintLock.writeProtected {
            constraints.removeAll()
            constraints.append(Constraint(signalType: Signal.self, state: .enabled).term)
        }
    }

    public static func disableAllSignals() {
        constraintLock.writeProtected {
            constraints.removeAll()
            constraints.append(Constraint(signalType: Signal.self, state: .disabled).term)
        }
    }

    // MARK: - Querying

    public static func state(of aSignalType: Signal.Type, constrainedTo aLogger: SignalLogger, on aBeacon: Beacon) -> State? {
        let kb = KnowledgeBase(knowledge: List.axioms + axioms + rules + constraints)
        let answers = kb.ask(
            findAllConstraints(.var("state"), .var("signal"), .logger(aLogger), .beacon(aBeacon))
                && signalHierarchy(.signal(aSignalType), .var("thisSignalHierarchy"), .var("thisSignalValue"))
                && signalHierarchy(.var("signal"), .var("signalHierarchy"), .var("signalValue"))
                && List.contains(list: .var("signalHierarchy"), element: .var("signal"))
                && List.contains(list: .var("thisSignalHierarchy"), element: .var("signal"))
        )
        let result = answers.max { a, b in
            Nat.asSwiftInt(a["signalValue"]!)! < Nat.asSwiftInt(b["signalValue"]!)!
        }
        return result?["state"] == .signalState(.enabled) ? .enabled : .disabled
    }

    // MARK: Describing

    public static var current: [Constraint] {
        var results: [Constraint] = .init()
        var kb: KnowledgeBase!
        constraintLock.readProtected {
            kb = KnowledgeBase(knowledge: constraints)
        }
        let answers = kb.ask(
            constraint(.var("signal"), .var("state"), .var("logger"), .var("beacon"))
        )
        answers.forEach { a in
            guard let signalClassName = a["signal"]?.extractValue(ofType: String.self),
                  let signalClass = NSClassFromString(signalClassName) as? Signal.Type,
                  let stateString = a["state"]?.extractValue(ofType: String.self),
                  let state = State(rawValue: stateString)
            else { return }
            let logger = a["logger"]?.extractValue(ofType: SignalLogger.self)
            let beacon = a["beacon"]?.extractValue(ofType: Beacon.self)
            let constraint = Constraint(signalType: signalClass, state: state, logger: logger, beacon: beacon)
            results.append(constraint)
        }
        return results
    }

    public static var currentDescription: String {
        current.map { $0.description }.joined(separator: "\n")
    }
}

// MARK: - Variables

private var constraintLock: RWLock = .init()

// MARK: - Functors

private let constraint = "constraint"/4
private let findAllConstraints = "findAllConstraints"/4
private let signalHierarchy = "signalHierarchy"/3

@inline(__always)
private func className(of aClass: AnyClass) -> String {
    NSString(cString: class_getName(aClass), encoding: NSUTF8StringEncoding)! as String
}

// MARK: - Rules & Axioms

private var axioms: [Term] = Signal.withAllSubclasses.map { aClass in
    let nsClass = aClass as! NSObject.Type
    let superClasses = nsClass.withAllSuperclasses
    let terms: [Term] = superClasses.map { .lit(className(of: $0)) }
    return signalHierarchy(.lit(className(of: nsClass)), List.from(elements: terms), Nat.from(superClasses.count))
}

private var constraints: [Term] = [constraint(.signal(Signal.self), .signalState(.enabled), .any, .any)]

private var rules: [Term] = [
    findAllConstraints(.var("state"), .var("signal"), .var("logger"), .var("beacon")) |-
        constraint(.var("signal"), .var("state"), .var("logger"), .var("beacon"))
        || constraint(.var("signal"), .var("state"), "any", .var("beacon"))
        || constraint(.var("signal"), .var("state"), .var("logger"), "any")
        || constraint(.var("signal"), .var("state"), "any", "any")
]

// MARK: - CustomStringConvertible

extension Constraint: CustomStringConvertible {
    public var description: String {
        let base = "\(state == .enabled ? "+" : "-")\(signalType)"
        if let logger, let beacon {
            return "\(base) ~> (\(logger), \(beacon))"
        }
        if let logger {
            return "\(base) ~> \(logger)"
        }
        if let beacon {
            return "\(base) ~> \(beacon)"
        }
        return base
    }
}

// MARK: - Equatable

extension Constraint: Equatable {
    public static func ==(lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs.signalType === rhs.signalType
            && lhs.state == rhs.state
            && lhs.logger == rhs.logger
            && lhs.beacon == rhs.beacon
    }
}
