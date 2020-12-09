//
//  SignalStringConvertible.swift
//  
//
//  Created by Pavel Skaldin on 12/8/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Foundation

protocol SignalStringConvertible {
    var shortDescription: String { get }
    var longDescription: String { get }
}
