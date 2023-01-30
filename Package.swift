// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "WombatAuth",
    products: [
        .library(name: "WombatAuth", targets: ["WombatAuth"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "WombatAuth", path: "Frameworks/WombatAuth.xcframework"),
    ]
)