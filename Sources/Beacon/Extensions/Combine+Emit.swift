//
//  Publisher+Emit.swift
//
//
//  Created by Pavel Skaldin on 5/8/24.
//

import Combine
import Foundation

public extension Publisher
{
    // Subscribes to the given `Subject`
    func emit<S: Subscriber>(userInfo: Any? = nil, source: Source = .init(), on subject: S)
        where S.Input == Signal,
        S.Failure == Never,
        Failure == S.Failure,
        Output == S.Input
    {
        subscribe(subject)
    }

    // Maps any value to an appropriate type of `Signal` and subscribes to the resulting `Publisher`.
    // The type of signal is derived using `Signal.representing()`.
    func emit<S: Subscriber, V: Any>(userInfo: Any? = nil, source: Source = .init(), on subject: S)
        where S.Input == Signal,
        S.Failure == Never,
        Failure == S.Failure,
        Output == V
    {
        map { Signal.representing($0, userInfo: userInfo, source: source) }
            .subscribe(subject)
    }
}
