//
//  JRPCLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a logger for a JSON RPC service.
 
 I am an interval logger, and as such, I collect signals into a queue
 which I process at regular intervals. When I process my queue, I initiate
 a POST request to a JSON RPC service, with all the signals I've collected
 to that point, and I refrain from making additional network requests until
 I am finished with the current one.
 */

@available(*, message: "mocked")
open class JRPCLogger: IntervalLogger {
    
    // MARK: - Variables
    
    /// Base URL to the JSON RPC server
    @objc open private(set) var url: URL!
    
    /// JRPC Method to call
    @objc open private(set) var method: String!
    
    /// JSONEncoder for encoding signals.
    var encoder: SignalEncoder = JSONSignalEncoder()
    
    // MARK: - Variables (private)
    
    internal var urlSessionTask: URLSessionTask?
    
    internal var lastCompletionDate: Date?
    
    // MARK: - Structs
    
    private struct Method : Encodable {
        static private var counter: Int = 0
        static private func nextId() -> Int {
            counter += 1
            return counter
        }
        
        private(set) var version = "2.0"
        var id: Int
        var method: String
        var arguments: [Data]
        
        var json: String {
            let args = arguments.compactMap { (anArgument) -> String? in
                return String(data: anArgument, encoding: .utf8)
            }
            // I don't want to do things this way, and would really love to use Codable approach here,
            // but it's such a pain in the ass. Arguments are already encoded, they just need to be written out verbatim
            // to the resulting stream - but I couldn't figure out how to do that with JSONEncoder and Codable objects.
            // Plus, this is SOOO much less code than the Codable approach.
            return "{\"jsonrpc\":\"\(version)\",\"id\":\(id),\"method\":\"\(method)\",\"params\":[[\(args.joined(separator: ","))]]}"
        }
        
        init(method aMethod: String, arguments args: [Data] = [Data]()) {
            id = Method.nextId()
            method = aMethod
            arguments = args
        }
    }
    
    // MARK: - Instance Creation
    
    public class func starting<T:JRPCLogger>(url anUrl: URL, method aMethod: String, name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: Filter? = nil) -> T {
        let me = self.init(url: anUrl, method: aMethod, name: aName)
        me.subscribe(to: beacons, filter: filter)
        return me as! T
    }
    
    override open class func starting<T>(name aName: String, on beacons: [Beacon] = [Beacon.shared], filter: SignalLogger.Filter? = nil) -> T where T : SignalLogger {
        fatalError("Use JRPCLogger.starting(url:method:name:on:filter:)")
    }
    
    // MARK: - Init
    
    @objc required public init(url anUrl: URL, method aMethod: String, name aName: String, interval anInterval: TimeInterval = 3, queue aQueue: DispatchQueue? = nil) {
        url = anUrl
        method = aMethod
        super.init(name: aName, interval: anInterval, queue: aQueue)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Use init(url:name:) to instantiate")
    }
    
    required public init(name aName: String, interval anInterval: TimeInterval, queue aQueue: DispatchQueue? = nil) {
        fatalError("init(name:interval:queue:) has not been implemented")
    }
    
    // MARK: - Encoding
    
    override func encodeSignal(_ aSignal: Signal) -> Data? {
        do {
            return try encoder.encode(aSignal)
        }
        catch {
            print("Error encoding signal: \(error)")
        }
        return nil
    }
    
    // MARK: - Flushing
    
    override open var shouldFlush: Bool {
        return super.shouldFlush && isReadyToFlush
    }
    
    private var isReadyToFlush: Bool {
        guard urlSessionTask == nil else { return false }
        guard let lastCompletionDate = lastCompletionDate else { return true }
        return Date().timeIntervalSince(lastCompletionDate) > flushInterval
    }
    
    override open func flush() {
        let buffer = self.buffer
        guard let urlRequest = createUrlRequest(with: buffer) else { return }
        perform(urlRequest: urlRequest) { (success) in
            self.urlSessionTask = nil
            guard success else { return }
            self.buffer.removeFirst(buffer.count)
        }
    }
    
    // MARK: - Networking
    
    internal func createUrlRequest(with data: [Data]) -> URLRequest? {
        let jrpcMethod = Method(method: method, arguments: data)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jrpcMethod.json.data(using: .utf8)
        return urlRequest
    }
    
    internal func perform(urlRequest: URLRequest, completion:((Bool)->Void)? = nil) {
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
