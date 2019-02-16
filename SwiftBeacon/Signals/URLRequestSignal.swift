//
//  URLRequestSignal.swift
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 2/15/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I am a `BeaconSignal` that represents an `URLRequest`.
 */
class URLRequestSignal : BeaconSignal {
    private(set) var request: URLRequest
    
    public override class var signalName: String {
        return "📡 \(classSignalName)"
    }
    
    public init(_ aRequest: URLRequest, source: BeaconSignal.Source? = nil, userInfo: [AnyHashable : Any]? = nil) {
        request = aRequest
        super.init()
    }
    
    public override var description: String {
        let url: URL? = request.url
        var urlDescription = ""
        if let method = request.httpMethod {
            urlDescription += "\(method) "
        }
        if let url = url {
            urlDescription += "\(url)"
        }
        return "\(super.description) \(urlDescription)"
    }
}

extension URLRequest : BeaconSignaling {
    public var beaconSignal: BeaconSignal {
        return URLRequestSignal(self)
    }
}

