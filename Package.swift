import PackageDescription

let package = Package(
    name: "SeeURL",
    dependencies: [
        .Package(url: "https://github.com/novi/CcURL.git", majorVersion: 1),
        .Package(url: "git@bitbucket.org:shiroyagi/swift-curl.git", majorVersion: 0)
    ],
    targets: [
        Target(
            name: "UnitTests",
            dependencies: [.Target(name: "SeeURL")]),
        Target(
            name: "SeeURL")
    ],
    exclude: ["UnitTests"]
)
