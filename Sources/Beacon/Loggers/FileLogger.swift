//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/17/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

open class FileLogger : SignalLogger {
    
    /// File URL where signals are written to
    @objc open private(set) var url: URL!
    
    @objc required public init(url anUrl: URL, name: String) {
        url = anUrl
        super.init(name: name)
    }
    
    @objc public required init(name aName: String) {
        fatalError("Use init(url:name:) to instantiate")
    }
}
