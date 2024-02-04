//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Implementation

extension Publisher {
    func emit<S: Subject>(on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable 
    where Output: Signaling, S.Output == Signal {
        return map { $0.signal }.emit(on: aSubject, fileName: aFileName, line: aLine, functionName: aFunctionName)
    }

    func emit<S: Subject>(on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable 
    where Output == Signal, S.Output == Output {
        var result: AnyCancellable!
        let subscriber = AnySubscriber<Output, Failure> { aSubscription in
            aSubscription.request(.unlimited)
            result = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { signal in
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubject.send(signal)
            return .unlimited
        } receiveCompletion: { completion in
            guard case let .failure(error) = completion else { return }
            let signal = ErrorSignal(error: error)
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubject.send(signal)
        }

        subscribe(subscriber)
        return result
    }

    func emit<S: Logger>(on aSubscriber: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) where Output == Signaling {
        map { $0.signal }.subscribe(aSubscriber)
    }

    func emit<S: Logger>(on aSubscriber: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
        subscribe(aSubscriber)
    }
}

// MARK: - Logger

class PluggableLogger<Input: Signal, Failure: Error>: Subscriber {
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        print("Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("\(input)")
        return .unlimited
    }
}

class Logger: Subscriber {
    typealias Input = Signal
    typealias Failure = Error

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        print("Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("\(input)")
        return .unlimited
    }
}

class CollectingLogger: Subscriber {
    typealias Input = [Signal]
    typealias Failure = Error

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
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

class Signal: CustomStringConvertible {
    var source: Source?
    var description: String { "\(source?.description ?? "")" }
}

class StringSignal: Signal {
    var string: String

    override var description: String { "\(source?.description ?? "") <String: \"\(string)\">" }

    init(string: String, source: Source = .init(origin: "Playground")) {
        self.string = string
        self.source = source
    }
}

class ErrorSignal: Signal {
    var error: Error

    override var description: String { "\(source?.description ?? "") Error: \(error)" }

    init(error: Error, source: Source = .init(origin: "Playground")) {
        self.error = error
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

func emit<S, V>(_ aValue: V, on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function)
    where S: Subject, S.Output == Signal, V: Signaling
{
    let signal = aValue.signal
    signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
    aSubject.send(signal)
}

func emit<S, V>(_ aValue: V, on aSubscriber: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function)
    where S: Logger, V: Signaling
{
    let signal = aValue.signal
    signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
    Just(signal).eraseToAnyPublisher().subscribe(aSubscriber)
}


// MARK: - Loggers

let logger = Logger()
let pluggableLogger = PluggableLogger<StringSignal, URLError>()

let collectingLogger = CollectingLogger()

// MARK: - Publishers

let url = URL(string: "https://localhost/nothing/in/particular")!
let dataTaskPublisher: URLSession.DataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)

let foo = dataTaskPublisher.map { StringSignal(string: "\($0.0)") }

foo.subscribe(pluggableLogger)

let numberPublisher = (1 ..< 3).publisher

let loggingSubject = PassthroughSubject<Signal, Error>()

// MARK: - Subscribing loggers

loggingSubject
    .subscribe(logger)

loggingSubject
    .collect(3)
    .subscribe(collectingLogger)

// MARK: - Emitting

let c = dataTaskPublisher
    .map { "📡 \($0)" }
    .emit(on: loggingSubject)

numberPublisher
    .map { "#️⃣ \($0)" }
    .emit(on: logger)

// MARK: - Emitting without publishers

func directTest() {
    emit("Via Subject", on: loggingSubject)
    emit("Via Logger", on: logger)
}

directTest()

//: [Next](@next)
