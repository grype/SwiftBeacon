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

open class FileWheel: FileRotation {
    public typealias RotationBlock = (_ url: URL) throws -> Void
    
    public typealias ConditionBlock = (_ url: URL) -> Bool
    
    // MARK: - Variables
    
    /// Condition that needs to be met before rotation file can be rotated.
    /// The block takes file URL and expected to return true if file at that location needs to be rotated.
    open var conditionBlock: ConditionBlock
    
    /// Block that performs actual file rotation.
    open var rotationBlock: RotationBlock
    
    // MARK: - Init
    
    public init(when aCondition: @escaping ConditionBlock, rotate aBlock: @escaping RotationBlock) {
        conditionBlock = aCondition
        rotationBlock = aBlock
    }
    
    // MARK: - Rotation
    
    /// Answer whether file at given URL should be rotated.
    open func shouldRotate(fileAt url: URL) -> Bool {
        return conditionBlock(url)
    }
    
    /// Rotates file at given URL or throws an error indicating why rotation failed.
    open func rotate(fileAt url: URL) throws {
        try rotationBlock(url)
    }
    
    /// Rotate file at given URL if it should be rotated.
    open func rotateIfNeeded(fileAt url: URL) throws {
        guard shouldRotate(fileAt: url) else { return }
        try rotate(fileAt: url)
    }
}
