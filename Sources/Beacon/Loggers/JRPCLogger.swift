//
//  JRPCLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

open class JRPCLogger: SignalLogger {
    
    /// MARK:- Properties
    
    /// Base URL to the JSON RPC server
    @objc public private(set) var url: URL!
    
    /// JRPC Method to call
    private(set) var method: String!
    
    private var signalQueue = [Signal]()
    
    private let queue = DispatchQueue(label: "JRPCLogger")
    
    private var urlSessionTask: URLSessionTask?
    
    private var lastCompletionDate: Date?
    
    // MARK:- Structs
    
    private struct MethodArgument : Encodable {
        var argument : Encodable
        
        func encode(to encoder: Encoder) throws {
            try argument.encode(to: encoder)
        }
        
        init(_ arg : Encodable) {
            argument = arg
        }
    }
    
    private struct Method : Encodable {
        static private var counter: Int = 0
        static private func nextId() -> Int {
            counter += 1
            return counter
        }
        
        private var version = "2.0"
        var id: Int
        var method: String
        var arguments: [MethodArgument]
        
        enum CodingKeys: String, CodingKey {
            case version = "jsonrpc", id, method, arguments = "params"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(version, forKey: .version)
            try container.encode(id, forKey: .id)
            try container.encode(method, forKey: .method)
            try container.encode([arguments], forKey: .arguments)
        }
        
        init(method aMethod: String, arguments args: [Encodable] = [Encodable]()) {
            id = Method.nextId()
            method = aMethod
            arguments = args.map { MethodArgument($0) }
        }
    }
    
    public class func starting<T:JRPCLogger>(url anUrl: URL, method aMethod: String, name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
        let me = self.init(url: anUrl, method: aMethod, name: aName)
        me.subscribe(to: beacons, filter: filter)
        return me as! T
    }
    
    // MARK: - Init
    
    @objc required public init(url anUrl: URL, method aMethod: String, name: String) {
        url = anUrl
        method = aMethod
        super.init(name: name)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Use init(url:name:) to instantiate")
    }
    
    override public func nextPut(_ aSignal: Signal) {
        queue.async {
            self.signalQueue.append(aSignal)
        }
    }
    
    override public func nextPutAll(_ signals: [Signal]) {
        queue.async {
            self.signalQueue.append(contentsOf: signals)
        }
    }
    
    override func didStart() {
        startTimer()
    }
    
    override func didStop() {
        stopTimer()
    }
    
    // MARK:- Timer
    
    var interval: TimeInterval = 2 {
        didSet {
            guard let timer = timer, timer.isValid else { return }
            stopTimer()
            startTimer()
        }
    }
    
    private var timer: Timer?
    
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(JRPCLogger.timerFired(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    @objc private func timerFired(_ timer: Timer) {
        queue.async {
            self.flushQueue()
        }
    }
    
    // MARK:- SignalQueue
    
    private var shouldFlushQueue: Bool {
        return urlSessionTask == nil
            && !signalQueue.isEmpty
            && (lastCompletionDate == nil ||  Date().timeIntervalSince(lastCompletionDate!) > interval)
    }
    
    private func flushQueue() {
        guard shouldFlushQueue, let urlRequest = createUrlRequest() else { return }
        
        let count = signalQueue.count
        perform(urlRequest: urlRequest) { (success) in
            self.urlSessionTask = nil
            guard success else { return }
            self.signalQueue.removeFirst(count)
        }
    }
    
    // MARK:- Networking
    
    private func createUrlRequest() -> URLRequest? {
        let jrpcMethod = Method(method: method, arguments: signalQueue)
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(jrpcMethod) else { return nil }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        return urlRequest
    }
    
    private func perform(urlRequest: URLRequest, completion:((Bool)->Void)? = nil) {
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            var success = false
            defer { completion?(success) }
            self.lastCompletionDate = Date()
            if let error = error {
                print("Error calling jrpc method: '\(String(describing: self.method))': \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Unexpected response from jrpc server")
                return
            }
            guard (200...299).contains(response.statusCode) else {
                print("Unexpected response from jrpc server: \(response.statusCode) \(response)")
                return
            }
            success = true
        }
        urlSessionTask = task
        task.resume()
    }
}

fileprivate extension WrapperSignal {
    enum CodingKeys : String, CodingKey {
        case value = "target"
    }
}
