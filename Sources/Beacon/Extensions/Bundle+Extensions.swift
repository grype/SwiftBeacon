//
//  File.swift
//
//
//  Created by Pavel Skaldin on 4/28/24.
//

import Combine
import Foundation

private var sharedSubject: PassthroughSubject<Signal, Never> = .init()

public extension Bundle {
    static var sharedBeacon: PassthroughSubject<Signal, Never> { return sharedSubject }
}
