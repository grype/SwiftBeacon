// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Beacon",
    products: [
        .library(name: "Beacon", targets: ["Beacon-iOS", "Beacon-tvOS", "Beacon-Mac", "Beacon-watchOS"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Beacon-iOS",
            dependencies: []),
        .testTarget(
            name: "Beacon-iOSTests",
            dependencies: ["Beacon"]),
        .target(
            name: "Beacon-tvOS",
            dependencies: []),
        .testTarget(
            name: "Beacon-tvOSTests",
            dependencies: ["Beacon-tvOS"]),
        .target(
            name: "Beacon-Mac",
            dependencies: []),
        .testTarget(
            name: "Beacon-MacTests",
            dependencies: ["Beacon-Mac"]),
        .target(
            name: "Beacon-watchOS",
            dependencies: []),
    ]
)
