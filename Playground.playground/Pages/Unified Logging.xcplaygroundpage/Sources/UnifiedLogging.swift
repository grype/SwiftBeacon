import Foundation
import OSLog

let logger = Logger(subsystem: "net.grype.logging", category: "playground")

public func log<T: CustomStringConvertible>(_ data: T) {
    logger.info("\(data, privacy: .public)")
}
