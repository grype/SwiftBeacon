//: [Previous](@previous)

import Beacon
import Foundation
import PlaygroundSupport

public typealias T = PlaygroundPage

public class PlaygroundPageSignal: WrapperSignal {
    var page: T { value as! T }
    init(_ aValue: T, userInfo anUserInfo: [AnyHashable : Any]? = nil) {
        super.init(aValue)
    }
    override public var signalName: String { "📃" }
    override public var valueDescription: String? {
        "\(super.valueDescription ?? "") needsInfiniteExecution: \(page.needsIndefiniteExecution)"
    }
}

extension T: Signaling {
    public var beaconSignal: PlaygroundPageSignal { .init(self) }
}

let logger = ConsoleLogger(name: "Playground Console")
logger.run { _ in
    emit(PlaygroundSupport.PlaygroundPage.current)
}

//: [Next](@next)
