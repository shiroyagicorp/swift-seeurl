import PackageDescription

#if os(macOS)
let package = Package(
    name: "SeeURL",
    dependencies: [.Package(url: "git@github.com:shiroyagicorp/swift-curl.git", majorVersion: 0)]
)
#else
let package = Package(
    name: "SeeURL",
    dependencies: [.Package(url: "https://github.com/novi/CcURL.git", majorVersion: 1)]
)
#endif
