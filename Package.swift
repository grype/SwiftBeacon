// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Beacon",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Beacon",
            targets: ["Beacon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.0.0")),
        .package(url: "https://github.com/grype/SwiftAnnouncements", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/grype/RWLock-Swift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Brightify/Cuckoo", .upToNextMajor(from: "1.3.0"))
    ],
    targets: {
        
        var targets: [Target] = [
            .testTarget(
                name: "BeaconTests",
                dependencies: ["Beacon", "Nimble", "SwiftAnnouncements", "Cuckoo"]),
        ]
        #if _runtime(_ObjC)
        targets.append(contentsOf: [
            .target(name: "BeaconObjcRuntime", dependencies: []),
            .target(name: "Beacon", dependencies: [ "BeaconObjcRuntime", "SwiftAnnouncements", "RWLock" ]),
        ])
        #else
        targets.append(contentsOf: [
            .target(name: "Beacon", dependencies: ["SwiftAnnouncements", "RWLock"], exclude: [ "Sources/BeaconObjcRuntime" ]),
        ])
        #endif
        return targets
    }()
)
