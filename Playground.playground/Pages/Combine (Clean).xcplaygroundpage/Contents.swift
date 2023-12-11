//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let logger = Logger()

// Beacon.shared
//    .subscribe(logger)
//
// Beacon.test
//    .subscribe(logger)

Beacon.shared
    .merge(with: Beacon.test)
//    .removeDuplicates(by: { $0 == $1 })
    .subscribe(logger)

let publisher = Timer.publish(every: 0.25, on: .current, in: .default).autoconnect()

let foo = publisher
    .map { "\($0.timeIntervalSince1970)" }
    .emit()
//    .subscribe(Beacon.shared)

let bar = publisher
    .map { "\($0.timeIntervalSince1970)" }
    .emit(on: .test)
//    .subscribe(Beacon.test)

let baz = publisher
    .map { "• \($0)" }
    .emit()

//Beacon.shared.send(StringSignal(string: "OMG"))
emit("OMG")

let baaz = publisher
    .map { "~~ \($0)" }
    .collect(.byTimeOrCount(DispatchQueue.global(), 3, 100))
    .sink { done in
        print("Done")
    } receiveValue: { values in
        print("values: \(values)")
    }


func emit<S: Signaling>(_ aValue: S, on aBeacon: Beacon = .shared, source: Source = .init(origin: "Playground")) {
    aBeacon.send(aValue.signal)
}

extension Publisher {
    func emit(on aBeacon: Beacon = .shared, source: Source = .init(origin: "Playground")) -> AnyCancellable where Output: Signaling {
        var result: AnyCancellable!
        let subscriber = AnySubscriber<Output,Failure> { aSubscription in
            aSubscription.request(.unlimited)
            result = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { aValue in
            aBeacon.send(aValue.signal)
            return .unlimited
        } receiveCompletion: { completion in
            print("DONE")
        }
        
        subscribe(subscriber)
        return result
    }
}

// MARK: - Beacon

class Beacon: Subject {
    typealias Output = any Signal

    typealias Failure = Never

    public static var beaconVersion = "2.1.4"

    /// Shared general-purpose instance
    public static var shared = Beacon()

    public static var test = Beacon()

    private var passthroughSubject: PassthroughSubject<Output, Failure> = .init()

    func send(_ value: Output) {
        passthroughSubject.send(value)
    }

    func send(completion: Subscribers.Completion<Failure>) {
        passthroughSubject.send(completion: completion)
    }

    func send(subscription: Subscription) {
        passthroughSubject.send(subscription: subscription)
    }

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        passthroughSubject.receive(subscriber: subscriber)
    }
}

// MARK: - Logger

class Logger: Subscriber {
    typealias Input = any Signal
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("\(input)")
        return .unlimited
    }
}

// MARK: - Signal

protocol Signal: CustomStringConvertible {
    var source: Source { get }
}

struct StringSignal: Signal {
    var string: String
    var source: Source

    var description: String { "<String: \(string))>" }

    init(string: String, source: Source = .init(origin: "Playground")) {
        self.string = string
        self.source = source
    }
}

// MARK: - Signaling

protocol Signaling {
    var signal: Signal { get }
}

extension String: Signaling {
    var signal: Signal { StringSignal(string: self) }
}

// MARK: - Source

#if os(iOS) || os(tvOS)
import UIKit
let UniqueDeviceIdentifier: String? = UIDevice.current.identifierForVendor?.uuidString
#elseif os(macOS)
import IOKit
let UniqueDeviceIdentifier: String? = {
    let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
    let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
    IOObjectRelease(platformExpert)
    return serialNumberAsCFString?.takeUnretainedValue() as? String
}()
#else
let UniqueDeviceIdentifier: String? = nil
#endif

public struct Source: CustomStringConvertible, Codable, Equatable {
    public var identifier: String? = UniqueDeviceIdentifier
    public var module: String?
    public var fileName: String
    public var line: Int
    public var functionName: String?

    public init(origin anOrigin: String?, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
        module = anOrigin
        fileName = aFileName
        line = aLine
        functionName = aFunctionName
    }

    public var description: String {
        var functionDescription = ""
        if var functionName = functionName {
            if !functionName.hasSuffix(")") {
                functionName += "()"
            }
            functionDescription = " #\(functionName)"
        }
        let filePrintName = fileName.components(separatedBy: "/").last ?? fileName
        let originName = (module != nil) ? "\(module!)." : ""
        return "[\(originName)\(filePrintName):\(line)]\(functionDescription)"
    }
}

//: [Next](@next)
