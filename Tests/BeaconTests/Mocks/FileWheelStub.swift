//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation
@testable import Beacon

class FileWheelStub : FileWheel {
    convenience init() {
        self.init(rotateOnStart: false, maxFileSize: 0, block: {_ in})
    }
    var stubbedRotateOnStart: Bool! = false
    override var rotateOnStart: Bool {
        set {
        }
        get {
            return stubbedRotateOnStart
        }
    }
    var stubbedMaxFileSize: UInt64! = 0
    override var maxFileSize: UInt64 {
        set {
        }
        get {
            return stubbedMaxFileSize
        }
    }
    var stubbedRotationBlock: RotationBlock!
    override var rotationBlock: RotationBlock! {
        set {
        }
        get {
            return stubbedRotationBlock
        }
    }
    var stubbedShouldRotateResult: Bool! = false
    override func shouldRotate(fileAt url: URL, for event: FileLogger.Event) -> Bool {
        return stubbedShouldRotateResult
    }
    override func rotate(fileAt url: URL) {
    }
    var stubbedFileExistsResult: Bool! = false
    override func fileExists(at url: URL) -> Bool {
        return stubbedFileExistsResult
    }
    var stubbedFileSizeResult: UInt64! = 0
    override func fileSize(at url: URL) -> UInt64 {
        return stubbedFileSizeResult
    }
}
