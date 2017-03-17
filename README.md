# SeeURL

[![Swift](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Swift](https://img.shields.io/badge/swift-3.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)

libcurl based HTTP(S) Client for Swift.

## Installation

* Add `SeeURL` to `Package.swift` of your project.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/shiroyagicorp/swift-seeurl.git", majorVersion: 1, minor: 6)
    ]
)
```

_Note:_ You may need to specify linker flags for libcurl while building your project.

```sh
swift build -Xlinker -L/usr/lib -Xlinker -lcurl
```


### Ubuntu

```sh
sudo apt-get install libcurl4-openssl-dev
```


## Usage

```swift
let result = try HTTPClient.sendRequest("GET", "https://google.com")
print(result.statusCode, result.body)
```

## LICENSE

MIT

### Acknowledgement

* [PureSwift/SeeURL](https://github.com/PureSwift/SeeURL)