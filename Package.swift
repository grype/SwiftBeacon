// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Beacon",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
        .tvOS(.v12),
        .watchOS(.v4),
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
        .package(name: "RWLock", url: "https://github.com/grype/RWLock-Swift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Brightify/Cuckoo", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/Flight-School/AnyCodable", .upToNextMajor(from: "0.5.0")),
    ],
    targets: {
        var targets: [Target] = [
            .target(
                name: "Beacon",
                dependencies: ["RWLock", "AnyCodable"],
                exclude: ["../BeaconObjcRuntime"]),
            .testTarget(
                name: "BeaconTests",
                dependencies: ["Beacon", "Nimble", "Cuckoo", "AnyCodable"]),
        ]
        #if _runtime(_ObjC)
        targets.append(contentsOf: [
            .target(name: "BeaconObjcRuntime", dependencies: ["Beacon"]),
        ])
        #endif
        return targets
    }())
