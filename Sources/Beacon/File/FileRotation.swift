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
    // Whether implemntor should be given a change to rotate file for given data,
    // before that data is written to the indicated file
    func shouldRotate(fileAt: URL, for: Data) -> Bool
    
    // Rotates file at given URL and returns Bool indicating successful operation
    func rotate(fileAt: URL) -> Bool
}
