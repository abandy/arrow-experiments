// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArrowGet",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(name: "Arrow", path: "vendor/Arrow"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.3.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "ArrowGet",
            dependencies: [
                .product(name: "Arrow", package: "Arrow"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
    ]
)
