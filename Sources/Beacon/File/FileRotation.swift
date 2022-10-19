//
//  FileRotation.swift
//
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I describe a protocol for rotating files.

 I am used by FileLogger for managing log files.
 */
public protocol FileRotation {
    func shouldRotate(fileAt: URL) -> Bool
    func rotate(fileAt: URL) throws
}
