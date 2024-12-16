// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConfettiView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ConfettiView",
            targets: ["ConfettiView"]),
    ],
    targets: [
        .target(
            name: "ConfettiView"),
    ]
)
