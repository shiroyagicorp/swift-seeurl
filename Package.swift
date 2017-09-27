import PackageDescription

let package = Package(
    name: "SeeURL",
    targets: [
        Target(name: "CcURL"),
        Target(name: "SeeURL", dependencies: ["CcURL"])
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/CCurl.git", majorVersion: 0, minor: 4),
    ]
)
