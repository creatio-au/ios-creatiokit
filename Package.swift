// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreatioKit",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "CreatioData", targets: ["CreatioData"]),
        .library(name: "CreatioGraphics", targets: ["CreatioGraphics"]),
        .library(name: "CreatioLocation", targets: ["CreatioLocation"]),
        .library(name: "CreatioUI", targets: ["CreatioUI"]),
        .library(name: "VersionChecker", targets: ["VersionChecker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "CreatioData", dependencies: []),
        .target(name: "CreatioGraphics", dependencies: []),
        .target(name: "CreatioLocation", dependencies: []),
        .target(name: "CreatioUI", dependencies: [.product(name: "Introspect", package: "SwiftUI-Introspect")]),
        .target(name: "VersionChecker", dependencies: []),
    ]
)
