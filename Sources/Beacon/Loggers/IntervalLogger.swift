//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/19/19.
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
open class IntervalLogger : SignalLogger {
    
    // MARK: - Variables
    
    @objc open var flushInterval: TimeInterval {
        didSet { restartFlushTimer() }
    }
    
    @objc private(set) var queue: DispatchQueue!
    
    @objc internal var buffer = [Signal]()
    
    internal var flushTimer: Timer?
    
    // MARK: - Init
    
    required public init(name aName: String, interval anInterval: TimeInterval, queue aQueue: DispatchQueue? = nil) {
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
            self.buffer.append(aSignal)
        }
    }
    
    override open func nextPutAll(_ signals: [Signal]) {
        queue.async {
            self.buffer.append(contentsOf: signals)
        }
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
    
    override func didStart() {
        startFlushTimer()
    }
    
    override func didStop() {
        stopFlushTimer()
    }
    
    // MARK: - Timer
    
    func startFlushTimer() {
        guard flushTimer == nil else { return }
        flushTimer = Timer.scheduledTimer(withTimeInterval: flushInterval, repeats: true, block: { (aTimer) in
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
