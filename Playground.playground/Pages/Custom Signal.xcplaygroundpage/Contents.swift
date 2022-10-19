//: [Previous](@previous)

import Beacon
import Foundation
import PlaygroundSupport

public class PlaygroundPageSignal: WrapperSignal {
    var page: PlaygroundPage { value as! PlaygroundPage }
    override public var signalName: String { "📃" }
    override public var valueDescription: String? {
        "\(super.valueDescription ?? "") needsInfiniteExecution: \(page.needsIndefiniteExecution)"
    }
}

extension PlaygroundPage: Signaling {
    public var beaconSignal: PlaygroundPageSignal { .init(self) }
}

let logger = ConsoleLogger(name: "Playground Console")
logger.run { _ in
    // Produces WrapperSignal
    emit(Date())
    
    // Produces PlaygroundPageSignal
    emit(PlaygroundSupport.PlaygroundPage.current)
}

//: [Next](@next)
