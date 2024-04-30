//: [Previous](@previous)

import Combine
import Foundation

// Define a protocol for loggers
protocol Logger: Subscriber where Input == String, Failure == Never {}

// Implement a console logger
class ConsoleLogger: Logger {
    typealias Input = String
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Never>) {
        switch completion {
        case .finished:
            print("Logging completed.")
        case .failure:
            print("Logging encountered an error.")
        }
    }
}

// Define a logging facility
class LoggingFacility {
    var subject: PassthroughSubject<String, Never>
    var cancellables: Set<AnyCancellable>

    init() {
        subject = PassthroughSubject<String, Never>()
        cancellables = Set<AnyCancellable>()
    }

    func addLogger(_ logger: some Logger) {
        subject
            .sink(receiveCompletion: logger.receive(completion:),
                  receiveValue: { aValue in logger.receive(aValue) })
            .store(in: &cancellables)
    }

    func log(_ message: String) {
        subject.send(message)
    }
}

// Usage
let loggingFacility = LoggingFacility()
let consoleLogger = ConsoleLogger()

loggingFacility.addLogger(consoleLogger)
loggingFacility.log("This is a test log message.")

//: [Next](@next)
