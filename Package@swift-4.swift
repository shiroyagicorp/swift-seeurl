// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SeeURL",
    products: [
        .library(name: "SeeURL", targets: ["SeeURL"]),
        
    ],
    targets: [
        .target(name: "CcURL"), 
        .target(name: "SeeURL", dependencies: ["CcURL"]),
        .testTarget(name: "SeeURLTests", dependencies: ["SeeURL"])
    ]
)

