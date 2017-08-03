import PackageDescription

let package = Package(
    name: "SeeURL",
    targets: [
        Target(name: "CcURL"),
        Target(name: "SeeURL", dependencies: ["CcURL"])
    ]
)
