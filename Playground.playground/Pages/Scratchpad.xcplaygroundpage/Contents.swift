//: [Previous](@previous)

import Beacon
import Foundation
import PlaygroundSupport

extension String: Error {}

let logger = ConsoleLogger(name: "Playground Console")
logger.run { _ in
    emit()
    emit("A Message")
    emit(Date())
    emit(URL(string: "http://example.com")!)
    do { throw "🦝" } catch { emit(error: error) }
}

//: [Next](@next)
