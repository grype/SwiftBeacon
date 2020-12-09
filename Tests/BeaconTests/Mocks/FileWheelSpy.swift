//
//  FileWheelSpy.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation
@testable import Beacon

class FileWheelSpy : FileWheel {
    convenience init() {
        self.init(maxFileSize: 0, block: { _ in
            return true
        })
    }
    var invokedMaxFileSizeSetter = false
    var invokedMaxFileSizeSetterCount = 0
    var invokedMaxFileSize: UInt64?
    var invokedMaxFileSizeList = [UInt64]()
    var invokedMaxFileSizeGetter = false
    var invokedMaxFileSizeGetterCount = 0
    var stubbedMaxFileSize: UInt64! = 0
    var forwardToOriginalMaxFileSize = true
    override var maxFileSize: UInt64 {
        set {
            invokedMaxFileSizeSetter = true
            invokedMaxFileSizeSetterCount += 1
            invokedMaxFileSize = newValue
            invokedMaxFileSizeList.append(newValue)
            if forwardToOriginalMaxFileSize {
                super.maxFileSize = newValue
            }
        }
        get {
            invokedMaxFileSizeGetter = true
            invokedMaxFileSizeGetterCount += 1
            if forwardToOriginalMaxFileSize {
                return super.maxFileSize
            }
            return stubbedMaxFileSize
        }
    }
    var invokedRotationBlockSetter = false
    var invokedRotationBlockSetterCount = 0
    var invokedRotationBlock: RotationBlock?
    var invokedRotationBlockList = [RotationBlock?]()
    var invokedRotationBlockGetter = false
    var invokedRotationBlockGetterCount = 0
    var stubbedRotationBlock: RotationBlock!
    var forwardToOriginalRotationBlock = true
    override var rotationBlock: RotationBlock! {
        set {
            invokedRotationBlockSetter = true
            invokedRotationBlockSetterCount += 1
            invokedRotationBlock = newValue
            invokedRotationBlockList.append(newValue)
            if forwardToOriginalRotationBlock {
                super.rotationBlock = newValue
            }
        }
        get {
            invokedRotationBlockGetter = true
            invokedRotationBlockGetterCount += 1
            if forwardToOriginalRotationBlock {
                return super.rotationBlock
            }
            return stubbedRotationBlock
        }
    }
    var invokedShouldRotate = false
    var invokedShouldRotateCount = 0
    var invokedShouldRotateParameters: (url: URL, data: Data)?
    var invokedShouldRotateParametersList = [(url: URL, data: Data)]()
    var stubbedShouldRotateResult: Bool! = false
    var forwardToOriginalShouldRotate = true
    override func shouldRotate(fileAt url: URL, for data: Data) -> Bool {
        invokedShouldRotate = true
        invokedShouldRotateCount += 1
        invokedShouldRotateParameters = (url, data)
        invokedShouldRotateParametersList.append((url, data))
        if forwardToOriginalShouldRotate {
            return super.shouldRotate(fileAt: url, for: data)
        }
        return stubbedShouldRotateResult
    }
    var invokedRotate = false
    var invokedRotateCount = 0
    var invokedRotateParameters: (url: URL, Void)?
    var invokedRotateParametersList = [(url: URL, Void)]()
    var forwardToOriginalRotate = true
    override func rotate(fileAt url: URL) -> Bool {
        invokedRotate = true
        invokedRotateCount += 1
        invokedRotateParameters = (url, ())
        invokedRotateParametersList.append((url, ()))
        if forwardToOriginalRotate {
            return super.rotate(fileAt: url)
        }
        return true
    }
    var invokedFileExists = false
    var invokedFileExistsCount = 0
    var invokedFileExistsParameters: (url: URL, Void)?
    var invokedFileExistsParametersList = [(url: URL, Void)]()
    var stubbedFileExistsResult: Bool! = false
    var forwardToOriginalFileExists = true
    override func fileExists(at url: URL) -> Bool {
        invokedFileExists = true
        invokedFileExistsCount += 1
        invokedFileExistsParameters = (url, ())
        invokedFileExistsParametersList.append((url, ()))
        if forwardToOriginalFileExists {
            return super.fileExists(at: url)
        }
        return stubbedFileExistsResult
    }
    var invokedFileSize = false
    var invokedFileSizeCount = 0
    var invokedFileSizeParameters: (url: URL, Void)?
    var invokedFileSizeParametersList = [(url: URL, Void)]()
    var stubbedFileSizeResult: UInt64! = 0
    var forwardToOriginalFileSize = true
    override func fileSize(at url: URL) -> UInt64 {
        invokedFileSize = true
        invokedFileSizeCount += 1
        invokedFileSizeParameters = (url, ())
        invokedFileSizeParametersList.append((url, ()))
        if forwardToOriginalFileSize {
            return super.fileSize(at: url)
        }
        return stubbedFileSizeResult
    }
}
