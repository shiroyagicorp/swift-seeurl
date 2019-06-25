// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "SeeURL",
    products: [
        .library(name: "SeeURL", targets: ["SeeURL"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/CCurl.git", .upToNextMajor(from: "0.4.1"))
    ],
    targets: [
        .target(name: "CcURLSwift"), 
        .target(name: "SeeURL", dependencies: ["CcURLSwift"]),
        .testTarget(name: "SeeURLTests", dependencies: ["SeeURL"])
    ]
)

