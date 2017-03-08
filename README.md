# SeeURL

[![Swift](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Swift](https://img.shields.io/badge/swift-3.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20tvos%20%7C%20linux-lightgrey.svg)](https://developer.apple.com/swift/)
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

_Note:_ You may need to specify library path for libmysqlclient to link with.

```sh
swift build -Xlinker -L/usr/lib -Xlinker -lcurl
```


### Ubuntu

```
sudo apt-get install libcurl4-openssl-dev
```


## Usage

```
let result = try HTTPClient.sendRequest("GET", "https://google.com")
print(result.statusCode, result.body)
```