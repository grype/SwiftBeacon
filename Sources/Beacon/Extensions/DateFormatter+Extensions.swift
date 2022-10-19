//
//  DateFormatter+Extensions.swift
//
//
//  Created by Pavel Skaldin on 8/16/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

public extension DateFormatter {
    enum BeaconFormat: String {
        case fileSortable = "yyyy-MM-dd-HH-mm-ss-SSS"
        case `default` = "yyyy-MM-dd HH:mm:ss.SSSZ"
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    }

    convenience init(format: BeaconFormat) {
        self.init()
        dateFormat = format.rawValue
    }
}
