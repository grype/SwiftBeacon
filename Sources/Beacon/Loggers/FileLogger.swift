//
//  FileLogger.swift
//
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

/**
 I log signals to a file, using their description.
 
 I am based on StreamLogger and provide additional mechanisms that are useful for managing files.
 One such mechanism is support for file rotation.
 */

open class FileLogger: SignalLogger {
    // MARK: - Types

    enum Error: Swift.Error, CustomStringConvertible {
        case createStream(URL)
        case writeStream(Swift.Error)
        case rotate(URL, Swift.Error)
        
        public var description: String {
            return switch self {
            case let .createStream(url):
                "Error creating stream at: \(url)"
            case let .rotate(url, error):
                "Error rotating log at '\(url)': \(error)"
            default:
                "Error"
            }
        }
    }
    
    public typealias Input = Signal
    
    public typealias Failure = Swift.Error
    
    // MARK: - Properties
    
    open private(set) var url: URL
    
    // Whether to rotate log file when receiving subscription.
    // This would only make sense if `wheel` is set.
    open var rotateOnSubscription = false
    
    // Optional object responsible for log rotation.
    // When provided, it will be given a chance to rotate
    // current log file at two stages: when the logger is
    // started, if `rotateOnStart` is true; and before
    // writing data into the curernt log file.
    open var wheel: FileRotation?
    
    public private(set) var name: String
    
    public private(set) var writer: EncodedStreamSignalWriter!
    
    // MARK: - Init
    
    public required init?(name aName: String, on anUrl: URL, encoder anEncoder: SignalEncoder) {
        name = aName
        url = anUrl
        guard let stream = OutputStream(url: anUrl, append: true) else {
            handle(error: Error.createStream(anUrl))
            return nil
        }
        writer = EncodedStreamSignalWriter(on: stream, encoder: anEncoder)
    }
    
    // MARK: - Receiving
    
    public func receive(subscription: Subscription) {
        defer { writer.open() }
        
        guard rotateOnSubscription else { return }
        
        do {
            try forceRotate()
            subscription.request(.unlimited)
        }
        catch {
            handle(error: .rotate(url, error))
            subscription.cancel()
        }
    }
    
    public func receive(_ input: Signal) -> Subscribers.Demand {
        rotateFileIfNeeded()
        
        do {
            try writer.write(input)
        }
        catch {
            handle(error: .writeStream(error))
            return .none
        }
        return .unlimited
    }
    
    func rotateFileIfNeeded() {
        if wheel?.shouldRotate(fileAt: url) ?? false {
            do {
                try forceRotate()
            }
            catch {
                handle(error: .rotate(url, error))
            }
        }
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        writer.close()
    }
    
    // MARK: - Error handling
    
    private func handle(error: Error) {
        print("Error: \(error)")
    }
    
    // MARK: - File
    
    open func forceRotate() throws {
        guard let wheel = wheel else { return }
        writer.close()
        try wheel.rotate(fileAt: url)
        writer.stream = OutputStream(url: url, append: true)!
        writer.open()
    }
}
