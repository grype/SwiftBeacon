//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Implementation

extension Publisher {
    func emit<S: Subject>(on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable
        where Output: Emittable, S.Output == any Signal
    {
        let source = Source(fileName: aFileName, line: aLine, functionName: aFunctionName)
        var result: AnyCancellable!
        let subscriber = AnySubscriber<Output, Failure> { aSubscription in
            aSubscription.request(.unlimited)
            result = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { anEmittable in
            var signal = anEmittable.signalValue
            signal.source = source
            aSubject.send(signal)
            return .unlimited
        } receiveCompletion: { completion in
            guard case let .failure(error) = completion else { return }
            var signal = ErrorSignal(error: error, source: Source(fileName: aFileName, line: aLine, functionName: aFunctionName))
            signal.source = source
            aSubject.send(signal)
        }
        subscribe(subscriber)
        return result
    }

    func emit<S: Subscriber>(on aSubscriber: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function)
        where Output: Emittable, S.Input == any Signal, Failure == S.Failure
    {
        let source = Source(fileName: aFileName, line: aLine, functionName: aFunctionName)
        map { aValue in
            var signal = aValue.signalValue
            signal.source = source
            return signal
        }.subscribe(aSubscriber)
    }
}

// MARK: - Logger

protocol Logger: AnyObject, Subscriber where Input: Emittable {}

class SimpleLogger<Input: Emittable, Failure: Error>: Logger {
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        print("SimpleLogger Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("\(input.signalValue.debugDescription)")
        return .unlimited
    }
}

class CollectingLogger: Logger {
    typealias Input = [Signal]
    typealias Failure = Error

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        print("CollectingLogger Done")
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        input.forEach {
            print("+\($0.debugDescription)")
        }
        return .unlimited
    }
}

// MARK: - Signal

protocol Signal: CustomStringConvertible, CustomDebugStringConvertible, Encodable, Emittable {
    var source: Source? { get set }
}

extension Signal {
    var description: String { "<\(type(of: self))>" }
    var debugDescription: String { "\(source?.description ?? "") \(description)" }
    var signalValue: Signal { self }
}

struct WrappedSignal<V: Encodable>: Signal {
    var value: V
    var source: Source?

    var description: String { "<Wrapped(\(type(of: value))): \"\(value)\">" }

    init(value: V, source: Source? = nil) {
        self.value = value
        self.source = source
    }
}

struct StringSignal: Signal {
    var source: Source?

    var string: String

    var description: String { "<String: \"\(string)\">" }

    init(string: String, source: Source? = nil) {
        self.string = string
        self.source = source
    }
}

struct ErrorSignal: Signal {
    var source: Source?

    var error: Error

    var description: String { "<Error(\(type(of: error)): \(error)>" }

    enum CodingKeys: String, CodingKey {
        case source, error
    }

    init(error: Error, source: Source? = nil) {
        self.error = error
        self.source = source
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encode(error.localizedDescription, forKey: .error)
    }
}

// MARK: - Emittable

protocol Emittable {
    var signalValue: Signal { get }
}

extension String: Emittable {
    var signalValue: Signal { StringSignal(string: self) }
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

    public init(bundle aBundle: Bundle = .main, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) {
        module = aBundle.infoDictionary?["CFBundleName"] as? String
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

// MARK: - Emitting

func emit<S: Subject, V: Emittable>(_ aValue: V, on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function)
    where S.Output == Signal
{
    var signal = aValue.signalValue
    signal.source = Source(fileName: aFileName, line: aLine, functionName: aFunctionName)
    aSubject.send(signal)
}

// MARK: - Loggers

let logger = SimpleLogger()

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
    .emit(on: loggingSubject)
//
//let ll = PluggableLogger<StringSignal, Never>()
//let cc = numberPublisher
//    .map { StringSignal(string: "#️⃣ \($0)") }
//    .emit(on: ll)


// MARK: - Emitting without publishers

func directTest() {
    emit("Direct", on: loggingSubject)
}

directTest()

//: [Next](@next)
