//
//  Data+Extensions.swift
//  
//
//  Created by Pavel Skaldin on 12/28/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

extension Data {
    func write(on stream: OutputStream) -> Int {
        withUnsafeBytes { (bytes) in
            guard let buffer = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0 }
            return stream.write(buffer, maxLength: count)
        }
    }
}
