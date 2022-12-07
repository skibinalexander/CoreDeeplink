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
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    ],
    targets: [
        .target(
            name: "CoreDeeplink",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
            ]
        )
    ]
)
