//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let publisher = Timer.publish(every: 0.25, on: .current, in: .default).autoconnect()
//let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://example.com/nothing/in/particular")!)

let logger = Logger()

let collectingLogger = CollectingLogger()

//typealias Beacon = PassthroughSubject<Signal, Never>
//let subject = Beacon()
let subject = PassthroughSubject<Signal, Never>()

subject
    .subscribe(logger)

subject
    .collect(3)
    .subscribe(collectingLogger)

publisher
    .map { StringSignal(string: "\($0.timeIntervalSince1970)") }
    .subscribe(logger)

let baz = publisher
    .map { "• \($0)" }
    .emit(on: subject)

func directTest() {
    emit("OMG", on: subject)
}
directTest()

func emit<S, V>(_ aValue: V, on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function)
    where S: Subject, S.Output == Signal, V: Signaling
{
    var signal = aValue.signal
    signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
    aSubject.send(signal)
}

extension Publisher {
    func emit<S: Subject>(on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable where Output: Signaling, S.Output == Signal {
        var result: AnyCancellable!
        let subscriber = AnySubscriber<Output, Failure> { aSubscription in
            aSubscription.request(.unlimited)
            result = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { aValue in
            var signal = aValue.signal
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubject.send(signal)
            return .unlimited
        } receiveCompletion: { _ in
            print("DONE")
        }

        subscribe(subscriber)
        return result
    }
}

// MARK: - Logger

class Logger: Subscriber{
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

class CollectingLogger: Subscriber {
    typealias Input = [Signal]
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        input.forEach {
            print("+\($0)")
        }
        return .unlimited
    }
}

// MARK: - Signal

protocol Signal: CustomStringConvertible {
    var source: Source { get set }
}

struct StringSignal: Signal {
    var string: String
    var source: Source

    var description: String { "\(source.description) <String: \"\(string)\">" }

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

    public init(origin anOrigin: String? = nil, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
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
