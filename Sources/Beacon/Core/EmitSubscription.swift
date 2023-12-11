//
//  File.swift
//
//
//  Created by Pavel Skaldin on 11/13/23.
//

import Combine
import Foundation

extension Publisher {
    func emit<S: Subject>(on aSubject: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable where Output: Signaling, S.Output == Signal {
        var cancellable: AnyCancellable!
        let subscriber = AnySubscriber<Output, Failure> { aSubscription in
            aSubscription.request(.unlimited)
            cancellable = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { aValue in
            let signal = aValue.beaconSignal
            signal.source = Source(module: Signal.bundleName, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubject.send(signal)
            return .unlimited
        } receiveCompletion: { completion in
            guard case let .failure(error) = completion else { return }
            var signal = ErrorSignal(error: error)
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubject.send(signal)
        }

        subscribe(subscriber)
        return cancellable
    }

    func emit<S: Subscriber, T: Signaling>(on aSubscriber: S, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String? = #function) -> AnyCancellable where Output == T, S.Input == Signal {
        var result: AnyCancellable!
        let subscriber = AnySubscriber<Output, Failure> { aSubscription in
            aSubscription.request(.unlimited)
            result = AnyCancellable { aSubscription.cancel() }
        } receiveValue: { aValue in
            var signal = aValue.signal
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubscriber.receive(signal)
            return .unlimited
        } receiveCompletion: { completion in
            guard case let .failure(error) = completion else { return }
            var signal = ErrorSignal(error: error)
            signal.source = Source(origin: nil, fileName: aFileName, line: aLine, functionName: aFunctionName)
            aSubscriber.receive(signal)
        }

        subscribe(subscriber)
        return result
    }
}
