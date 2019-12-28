//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation

/**
 I log signals to a file, using their description.
 
 I am based on StreamLogger and provide additional mechanisms that are useful for managing files.
 One such mechanism is support for file rotation.
 */

open class FileLogger : StreamLogger {
    
    public enum Event {
        case start, put(size: Int)
    }
    
    var fileRotation: FileRotation?
    
    override func didStart() {
        if let url = url, fileRotation?.shouldRotate(fileAt: url, for: .start) ?? false {
            fileRotation?.rotate(fileAt: url)
        }
        super.didStart()
    }
    
    override open func nextPut(_ aSignal: Signal) {
        if let url = url, fileRotation?.shouldRotate(fileAt: url, for: .put(size: encoder.encodedSize(of: aSignal))) ?? false {
            fileRotation?.rotate(fileAt: url)
        }
        super.nextPut(aSignal)
    }
    
}
