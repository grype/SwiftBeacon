//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/20/19.
//

import Foundation

open class StreamLogger : SignalLogger {
    
    private(set) var url: URL?
    
    var stream: OutputStream
    
    var encoder: SignalEncoding
    
    @objc(initWithName:onStream:encoder:)
    public required init(name aName: String, on aStream: OutputStream, encoder anEncoder: SignalEncoding) {
        stream = aStream
        encoder = anEncoder
        super.init(name: aName)
    }
    
    @objc(initWithName:onURL:encoder:)
    public convenience init(name aName: String, on anUrl: URL, encoder: SignalEncoding) {
        self.init(name: aName, on: OutputStream(url: anUrl, append: true)!, encoder: encoder)
        url = anUrl
    }
    
    @objc public required init(name aName: String) {
        fatalError("Instantiate with init(name:on:)")
    }
    
    override func didStart() {
        super.didStart()
        if let url = url {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: url.path) {
                fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
        }
        stream.open()
    }
    
    override func didStop() {
        super.didStop()
        stream.close()
    }
    
    override open func nextPut(_ aSignal: Signal) {
        encoder.encode(aSignal, on: stream)
    }
    
}
