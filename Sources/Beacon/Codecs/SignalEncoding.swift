//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/23/19.
//

import Foundation

@objc public protocol SignalEncoding {
    func encode(_ aSignal: Signal, on aStream: OutputStream)
}
