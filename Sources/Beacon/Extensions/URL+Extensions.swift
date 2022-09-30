//
//  URL+Extensions.swift
//
//
//  Created by Pavel Skaldin on 9/30/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

extension URL {
    var createdDate: Date? {
        try? resourceValues(forKeys: [.creationDateKey]).creationDate
    }
}
