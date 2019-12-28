//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation

/**
 I describe a protocol for rotating files.
 
 I am used by FileLogger for managing log files.
 */
public protocol FileRotation {
    // Whether implementor should rotate file at given URL for a given event.
    // For example, whether file needs to be rotated when logger is started
    // or when logging a signal as part of normal operation
    func shouldRotate(fileAt: URL, for: FileLogger.Event) -> Bool
    
    // Rotates file at given URL
    func rotate(fileAt: URL)
}
