// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "union-confetti",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UnionConfetti",
            targets: ["UnionConfetti"]),
    ],
    targets: [
        .target(
            name: "UnionConfetti"),
    ]
)
