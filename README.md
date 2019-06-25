# SeeURL

[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)
[![CircleCI](https://circleci.com/gh/shiroyagicorp/swift-seeurl.svg?style=svg)](https://circleci.com/gh/shiroyagicorp/swift-seeurl)

libcurl based HTTP(S) Client for Swift.

## Installation

* Add `SeeURL` to `Package.swift` of your project.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/shiroyagicorp/swift-seeurl.git", from: "1.9.0")
    ]
)
```


Swift 5.0 or later on Linux, you might need to install libcurl by `apt-get install libcurl4-openssl-dev`.

## Usage

```swift
import SeeURL
let result = try HTTPClient.sendRequest(method: "GET", url: "https://google.com")
print(result.statusCode, result.body)
```

## LICENSE

MIT

### Acknowledgement

* [PureSwift/SeeURL](https://github.com/PureSwift/SeeURL)