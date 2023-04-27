// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Beacon",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: {
        var libs: [Product] = [
            .library(
                name: "Beacon",
                targets: ["Beacon"]),
        ]
        #if _runtime(_ObjC)
        libs.append(.library(
            name: "BeaconObjcRuntime",
            targets: ["BeaconObjcRuntime"]))
        #endif
        return libs
    }(),
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "11.2.0")),
        .package(url: "https://github.com/grype/SwiftAnnouncements", .upToNextMajor(from: "1.0.3")),
        .package(url: "https://github.com/grype/RWLock-Swift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Brightify/Cuckoo", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/Flight-School/AnyCodable", .upToNextMajor(from: "0.5.0")),
        .package(url: "https://github.com/kyouko-taiga/LogicKit", .upToNextMajor(from: "2.1.0")),
    ],
    targets: {
        var targets: [Target] = [
            .target(
                name: "Beacon",
                dependencies: ["SwiftAnnouncements", "RWLock", "AnyCodable", "LogicKit"],
                exclude: ["../BeaconObjcRuntime"]),
            .testTarget(
                name: "BeaconTests",
                dependencies: ["Beacon", "Nimble", "SwiftAnnouncements", "Cuckoo", "AnyCodable"]),
        ]
        #if _runtime(_ObjC)
        targets.append(contentsOf: [
            .target(name: "BeaconObjcRuntime", dependencies: ["Beacon"]),
        ])
        #endif
        return targets
    }())
