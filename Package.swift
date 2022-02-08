// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "asyncCrash",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "asyncCrash",
            targets: ["asyncCrash"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "asyncCrash",
            dependencies: []
        )
    ]
)
