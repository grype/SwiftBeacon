//
//  SampleObject.swift
//  
//
//  Created by Pavel Skaldin on 12/10/20.
//

import Foundation

class SampleObject : Codable {
    
    var string: String?
    
    var int: Int?
    
    var float: Float?
    
    var double: Double?
    
    var bool: Bool?
    
    var date: Date?
    
    init() {
        string = "I am a string"
        int = 123
        float = 123.234
        double = 234.345
        bool = true
        date = Date()
    }
    
}
