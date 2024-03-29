//
//  IntervalLogger.swift
//
//
//  Created by Pavel Skaldin on 12/19/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a buffering logger that logs emitted signals using a timer.
 
 I am an abstract logger and have no conception of logging, I simply
 provide the necessary machinery for supporting periodic logging.
 
 For a concrete example, see JRPCLogger.
 
 Example:
 let logger = SubclassOfIntervalLogger(name: "Test", interval: 3)
 logger.start()
 logger.nextPut(StringSignal("test"))
 
 */

open class IntervalLogger: SignalLogger {
    // MARK: - Variables
    
    @objc open var flushInterval: TimeInterval {
        didSet { restartFlushTimer() }
    }
    
    @objc private(set) var queue: DispatchQueue!
    
    /// Maximum number of signals to store in the buffer. Older signals will be removed to accommodate new arrivals.
    @objc var maxBufferSize = 200
    
    @objc internal var buffer = [Data]()
    
    internal var flushTimer: Timer?
    
    // MARK: - Init
    
    public required init(name aName: String, interval anInterval: TimeInterval, queue aQueue: DispatchQueue? = nil) {
        flushInterval = anInterval
        super.init(name: aName)
        queue = aQueue ?? DispatchQueue(label: String(describing: type(of: self)))
    }
    
    @objc public required init(name aName: String) {
        fatalError("Instantiate with init(name:interval:queue:)")
    }
    
    // MARK: - Logging
    
    override open func nextPut(_ aSignal: Signal) {
        queue.async {
            guard let data = self.encodeSignal(aSignal) else {
                return
            }
            self.buffer.append(data)
            self.fixBuffer()
        }
    }
    
    override open func nextPutAll(_ signals: [Signal]) {
        queue.async {
            self.buffer.append(contentsOf: signals.compactMap { aSignal -> Data? in
                self.encodeSignal(aSignal)
            })
            self.fixBuffer()
        }
    }
    
    private func fixBuffer() {
        // be sure to call on `queue`
        buffer.removeFirst(max(0, buffer.count - maxBufferSize))
    }
    
    // MARK: - Encoding
    
    func encodeSignal(_ aSignal: Signal) -> Data? {
        fatalError("This logger did not implement signal encoding!")
    }
    
    // MARK: - Flushing
    
    @objc open var shouldFlush: Bool {
        return !buffer.isEmpty
    }
    
    @objc open func flush() {
        fatalError("Subclass had to override flush()")
    }
    
    private func flushIfPossible() {
        guard shouldFlush else { return }
        flush()
    }
    
    // MARK: - Starting/Stopping
    
    override func didStart(on beacons: [Beacon]) {
        super.didStart(on: beacons)
        startFlushTimer()
    }
    
    override func didStop() {
        super.didStop()
        stopFlushTimer()
    }
    
    // MARK: - Timer
    
    func startFlushTimer() {
        guard flushTimer == nil else { return }
        flushTimer = Timer.scheduledTimer(withTimeInterval: flushInterval, repeats: true, block: { _ in
            self.queue.async {
                self.flushIfPossible()
            }
        })
    }
    
    func stopFlushTimer() {
        guard let timer = flushTimer else { return }
        timer.invalidate()
        flushTimer = nil
    }
    
    private func restartFlushTimer() {
        stopFlushTimer()
        startFlushTimer()
    }
}
