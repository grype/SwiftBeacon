//
//  JRPCLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 2/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

/**
 I am a logger for a JSON RPC service.
 
 I am an interval logger, and as such, I collect signals into a queue
 which I process at regular intervals. When I process my queue, I initiate
 a POST request to a JSON RPC service, with all the signals I've collected
 to that point, and I refrain from making additional network requests until
 I am finished with the current one.
 */

open class JRPCLogger: SignalLogger {
    // MARK: - Types
    
    public typealias Input = [Signal]
    
    public typealias Failure = Error
    
    public enum Error: Swift.Error {
        case encoding
    }
    
    // MARK: - Variables
    
    open private(set) var name: String
    
    /// Base URL to the JSON RPC server
    @objc open private(set) var url: URL!
    
    /// JRPC Method to call
    @objc open private(set) var method: String!
    
    /// JSONEncoder for encoding signals.
    var encoder: SignalEncoder = JSONSignalEncoder()
    
    // MARK: - Variables (private)
    
    internal var urlSessionTasks: [URLSessionTask] = []
    
    // MARK: - Structs
    
    private struct Method: Encodable {
        private static var counter: Int = 0
        private static func nextId() -> Int {
            counter += 1
            return counter
        }
        
        private(set) var version = "2.0"
        var id: Int
        var method: String
        var arguments: [Data]
        
        var json: String {
            let args = arguments.compactMap { anArgument -> String? in
                String(data: anArgument, encoding: .utf8)
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
    
    // MARK: - Init
    
    public required init(url anUrl: URL, method aMethod: String, name aName: String) {
        url = anUrl
        method = aMethod
        name = aName
    }
    
    // MARK: - Receiving
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        do {
            let payload = try input.map { try encoder.encode($0) }
            let urlRequest = createUrlRequest(with: payload)
            perform(urlRequest: urlRequest)
            return .unlimited
        }
        catch {
            return .none
        }
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        urlSessionTasks.forEach { $0.cancel() }
    }
    
    // MARK: - Networking
    
    func createUrlRequest(with data: [Data]) -> URLRequest {
        let jrpcMethod = Method(method: method, arguments: data)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jrpcMethod.json.data(using: .utf8)
        return urlRequest
    }
    
    func perform(urlRequest: URLRequest) {
        let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            defer { self.cleanSessionTasks() }
            if let error = error {
                print("Error calling jrpc method: '\(String(describing: self.method))': \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Unexpected response from jrpc server")
                return
            }
            guard (200 ... 299).contains(response.statusCode) else {
                print("Unexpected response from jrpc server: \(response.statusCode) \(response)")
                return
            }
        }
        urlSessionTasks.append(task)
        task.resume()
    }
    
    func cleanSessionTasks() {
        urlSessionTasks.removeAll { $0.state == .completed }
    }
}

private extension WrapperSignal {
    enum CodingKeys: String, CodingKey {
        case value = "target"
    }
}
