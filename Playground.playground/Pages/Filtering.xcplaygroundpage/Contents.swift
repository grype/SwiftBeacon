//: [Previous](@previous)

import Beacon
import Foundation
import PlaygroundSupport

extension String: Error {}

let console = ConsoleLogger(name: "Console")

func doIt() {
    console.run { _ in
        if willLog(type: StringSignal.self, on: [.shared]) {
            // will log a string signal only if there's a running logger listening on .shared beacon
            // and there aren't any constraints prohibiting it
            emit("Logging string signal")
        } else {
            // otherwise, this will get logged, and that's because
            // we're not filtering out ErrorSignal's anywhere
            emit(error: "WARNING: String signals are disabled!")
        }
    }
}

StringSignal.disable(loggingTo: console, on: nil)
doIt()

StringSignal.enable(loggingTo: console, on: nil)
doIt()

//: [Next](@next)
