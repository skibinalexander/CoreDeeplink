// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDeeplink",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "CoreDeeplink",
            targets: ["CoreDeeplink"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreDeeplink",
            dependencies: [])
    ]
)
