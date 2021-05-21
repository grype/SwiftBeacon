//
//  FileWheel.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I rotate files using pluggable logic.
 
 When asked, I will use the `conditionBlock` to respond whether or not rotation should occur.
 And `rotationBlock` to perform the actual rotation.
 */
open class FileWheel : FileRotation {
    
    public typealias RotationBlock = (_ url: URL) throws -> Void
    
    public typealias ConditionBlock = (_ url: URL, _ data: Data) -> Bool
    
    // MARK: - Variables
    
    // Max file size, in bytes, that log file should not exceed
    open var conditionBlock: ConditionBlock
    
    // Block should perform log rotation and return Bool value indicating whether the file was rotated.
    open var rotationBlock: RotationBlock
    
    // MARK: - Init
    
    public init(when aCondition: @escaping ConditionBlock, rotate aBlock: @escaping RotationBlock) {
        conditionBlock = aCondition
        rotationBlock = aBlock
    }
    
    // MARK: - Rotation
    
    open func shouldRotate(fileAt url: URL, for data: Data) -> Bool {
        return conditionBlock(url, data)
    }
    
    open func rotate(fileAt url: URL) throws {
        try rotationBlock(url)
    }
}
