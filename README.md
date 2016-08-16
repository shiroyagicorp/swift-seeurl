# SeeURL

[![Swift](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20tvos%20%7C%20linux-lightgrey.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)

[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Swift wrapper for cURL

## Compiling on Ubuntu

First install SwiftFoundation [dependencies](https://github.com/PureSwift/SwiftFoundation#compiling-on-ubuntu).

```
sudo apt-get install libcurl4-openssl-dev
sudo cp cURLSwift.h /usr/include/curl
```

## Building libcurl for OS X
```
$ brew install openssl
$ cd curl-
$ ./configure --prefix=/usr/local/opt/curl --with-ssl=/usr/local/opt/openssl --with-ca-bundle=/usr/local/etc/openssl/cert.pem
$ make
$ make install
```