//: [Previous](@previous)

import Beacon
import Foundation
import PlaygroundSupport

let firstLogger = MemoryLogger(name: "First Logger")
let secondLogger = MemoryLogger(name: "Second Logger")
let firstBeacon = Beacon()
let secondBeacon = Beacon()

Constraint.clearAndActivate {
    -Signal.self
    +StringSignal.self ~> firstBeacon
    +ContextSignal.self ~> secondBeacon
}

Constraint.state(of: StringSignal.self, constrainedTo: secondLogger, on: secondBeacon)

firstLogger.start(on: [firstBeacon])
secondLogger.start(on: [secondBeacon])

emit("I am a string", on: [firstBeacon, secondBeacon])
emit(on: [firstBeacon, secondBeacon])
emit(123, on: [firstBeacon, secondBeacon])

print("\(firstLogger.name): ")
firstLogger.recordings.forEach { print($0.description) }

print("\(secondLogger.name): ")
secondLogger.recordings.forEach { print($0.description) }

[firstLogger, secondLogger].forEach { $0.stop() }

//: [Next](@next)
