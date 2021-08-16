//
//  DateFormatter+Extensions.swift
//  
//
//  Created by Pavel Skaldin on 8/16/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public enum BeaconFormat : String {
        case file = "yyyy-MM-dd-HH-mm-ss"
        case signal = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    }
    
    public convenience init(format: BeaconFormat) {
        self.init()
        dateFormat = format.rawValue
    }
    
    @objc public static var beaconSignalFormatter: DateFormatter { DateFormatter(format: .signal) }
    
    @objc public static var beaconFileFormatter: DateFormatter { DateFormatter(format: .file) }
    
}
