//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/10/24.
//

import Foundation

public struct Source: CustomStringConvertible, Codable {
    public var identifier: String? = UniqueDeviceIdentifier
    public var module: String?
    public var fileName: String
    public var line: Int
    public var functionName: String

    public init(bundle aBundle: Bundle = .main, fileName aFileName: String = #file, line aLine: Int = #line, functionName aFunctionName: String = #function) {
        module = aBundle.infoDictionary?["CFBundleName"] as? String
        fileName = aFileName
        line = aLine
        functionName = aFunctionName
    }

    public var description: String {
        var functionDescription = ""
        let functionNameSuffix = functionName.hasSuffix(")") ? "" : "()"
        functionDescription = " #\(functionName)\(functionNameSuffix)"
        let filePrintName = fileName.components(separatedBy: "/").last ?? fileName
        let originName = (module != nil) ? "\(module!)." : ""
        return "[\(originName)\(filePrintName):\(line)]\(functionDescription)"
    }
}
