//: [Previous](@previous)

import Foundation
import Beacon
import Combine
import SwiftUI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//extension Beacon {
//    static var tests: Beacon { .init() }
//}
//
//class TestSignal: StringSignal {
//    override open var signalName: String { "🔖" }
//}
//
//// 1. Create logger, which is a consumer of signals
//let logger = MemoryLogger(name: "Testing")
//
//// 2. Subscribe our logger to some streams of signals
//Beacon.tests
//    .merge(Beacon.shared)
//    .removeDuplicates()
//    .filter { $0 is StringSignal }
//    .map { TestSignal($0) }
//    .subscribe(logger)
//
//// 3. Emit signals
//emit("HELLO WORLD", on: [.shared, .tests])
//
//struct Model {
//    @Published var name: String
//}
//
//struct MyView: View {
//    @State var isWorking: Bool = false
//    @Bindable var model: Model
//    
//    init(isWorking: Bool, model: Model) {
//        self.isWorking = isWorking
//        self.model = model
//        model.$name.emit(on: [Beacon.shared, .test])
//    }
//    
//    var body: some View {
//        Text("Working: \(isWorking)")
//        Text("Model: \(model.name)")
//    }
//}

extension Beacon {
    static var cake: Beacon = .init()
}

Beacon.cake
    .subscribe(MemoryLogger.shared)
    .filter { $0 is ErrorSignal.self }
    .subscribe(ConsoleLogger.shared)

Timer.publish(every: 1, on: .main, in: .default)
    .map { "Count: \($0)" }
    .emit(on: [.cake])

struct Count: View {
    @State var count: Int = 0
    
    init() {
        emit(on: [.cake]) // logging call context
        $count.emit(on: [.cake]) // equivalent of emit(count, on: [.cake])
    }
}

// or, can we do this: ?

struct Count: View {
    @EmittingState(on: [.cake])
    var count: Int = 0
}

func doIt() {
    do {
        try something()
    }
    catch {
        emit(error: error, on: [.cake])
    }
}


//: [Next](@next)
