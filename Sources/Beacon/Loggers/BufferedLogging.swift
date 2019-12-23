//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/19/19.
//

import Foundation

protocol BufferedLoggingOld : class {
    /// Queue on which flush happens.
    var flushQueue: DispatchQueue! { get }
    
    /// Timer used for periodically calling flush()
    var flushTimer: Timer? { get set }
    
    /// Answers a boolean indicating whether flush should take place.
    /// Respond with false in the event that previous invocation of flush() hasn't finished yet.
    var shouldFlush: Bool { get }
    
    func startFlushTimer()
    func stopFlushTimer()
    func flush()
}

extension BufferedLoggingOld {
    
    var defaultFlushInterval: TimeInterval {
        return 3
    }
    
    func startFlushTimer() {
        guard flushTimer == nil else { return }
        let strongSelf = self
        flushTimer = Timer.scheduledTimer(withTimeInterval: defaultFlushInterval, repeats: true, block: { (aTimer) in
            strongSelf.flushQueue.async {
                guard strongSelf.shouldFlush else { return }
                strongSelf.flush()
            }
        })
    }
    
    func stopFlushTimer() {
        flushTimer?.invalidate()
        flushTimer = nil
    }
    
}

class BufferedStream<T> {
    
    // mark:- Type Aliases
    
    typealias FlushBlock = ([T], FlushCompletion) -> Void
    
    typealias FlushCompletion = () -> Void
    
    // mark:- Variables
    
    var flushInterval: TimeInterval! {
        didSet {
            restartFlushTimer()
        }
    }
    
    private(set) var flushBlock: FlushBlock!
    
    private(set) var queue: DispatchQueue!
    
    private var flushTimer: Timer?
    
    private(set) var isFlushing = false
    
    private(set) var buffer = [T]()
    
    // mark:- Init
    
    init(_ aBlock: @escaping FlushBlock, flushInterval anInterval: TimeInterval, queue aQueue: DispatchQueue? = nil) {
        flushBlock = aBlock
        flushInterval = anInterval
        queue = aQueue ?? DispatchQueue(label: String(describing: type(of: self)))
    }
    
    // mark:- Streaming
    
    func nextPut(_ value: T) {
        queue.async {
            self.buffer.append(value)
        }
    }
    
    // mark:- Flushing
    
    func flush() {
        queue.async {
            self.doFlush()
        }
    }
    
    private func doFlush() {
        guard !isFlushing else { return }
        willFlush()
        let items = buffer
        buffer.removeAll()
        flushBlock(items) {
            queue.async {
                self.didFlush()
            }
        }
    }
    
    private func willFlush() {
        isFlushing = true
    }
    
    private func didFlush() {
        isFlushing = false
    }
    
    // mark:- Starting/Stopping
    
    func startFlushTimer() {
        guard flushTimer == nil else { return }
        flushTimer = Timer.scheduledTimer(withTimeInterval: flushInterval, repeats: true, block: { (aTimer) in
            self.flush()
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
