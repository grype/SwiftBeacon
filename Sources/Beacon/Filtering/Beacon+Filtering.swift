//
//  Beacon+Filtering.swift
//
//
//  Created by Pavel Skaldin on 12/3/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

public extension Beacon {
    /// Indicates whether this instance will log signals of a given type.
    ///
    /// This is determined by whether:
    ///   * there are any running loggers observing this instance
    ///   * the given signal type (or its superclass) is enabled or disabled on this instance and/or an observing logger
    ///
    /// See ``Signal.enable(_:on:)`` and ``Signal.disable(_:on:)`` for more info
    func logsSignals<T: Signal>(ofType aType: T.Type) -> Bool {
        return announcer.allSubscribers.contains { anObject in
            guard let logger = (anObject as? SignalLogger), logger.isRunning else { return false }
            return Constraint.state(of: aType, constrainedTo: logger, on: self) == .enabled
        }
    }
}
