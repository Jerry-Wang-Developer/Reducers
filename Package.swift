// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reducers",
    platforms: [
        .iOS(.v17),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Reducers",
            targets: ["Reducers"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.23.1"
        ),
        .package(
            url: "https://github.com/tgrapperon/swift-dependencies-additions.git",
            branch: "xcode26"
        ),
        .package(
            url: "https://github.com/devicekit/DeviceKit.git",
            from: "5.7.0"
        ),
        .package(
            url: "https://github.com/Gaea-iOS/MobileCore.git",
            revision: "72d456f141489369b42bbc2f2367a774116059ac"
        ),
        .package(
            url: "https://github.com/SwiftyLab/MetaCodable.git",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
                .upToNextMinor(from: "1.2.1")
        ),
        .package(
            url: "https://github.com/kstenerud/KSCrash.git",
                .upToNextMajor(from: "2.3.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Reducers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
                .product(name: "DeviceKit", package: "DeviceKit"),
                .product(name: "MobileCore", package: "MobileCore"),
                .product(name: "MetaCodable", package: "MetaCodable"),
                .product(name: "HelperCoders", package: "MetaCodable"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Installations", package: "KSCrash")
            ]
        ),
        .testTarget(
            name: "ReducersTests",
            dependencies: ["Reducers"]
        ),
    ]
)
