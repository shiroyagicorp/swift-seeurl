//
//  HTTPClientTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//  Copyright © 2016 Shiroyagi Corporation. All rights reserved.
//

import CcURLSwift
import XCTest
import SeeURL
import Foundation

func containsInHeader(_ headers: [HTTPClient.Header], key: String, valueContains: String) -> Bool {
    for h in headers {
        if h.0.lowercased() == key.lowercased() && h.1.contains(valueContains) {
            return true
        }
    }
    return false
}


final class HTTPClientTests: XCTestCase {

    func testStatusCode() {
        
        let url = "http://httpbin.org/status/200"
        
        let response: HTTPClient.Response
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testSSLStatusCode() {
        
        let url = "https://httpbin.org/status/200"
        
        let response: HTTPClient.Response
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testResponseBody() throws {
        
        let url = "http://httpbin.org/user-agent"
        
        let response: HTTPClient.Response
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        let responseString = String(data: response.body, encoding: .utf8)!

        print(response.headers)
        
        XCTAssertTrue(containsInHeader(response.headers, key: "Content-Type", valueContains: "application/json"))
        
        guard let json = try JSONSerialization.jsonObject(with: response.body, options: []) as? [String: String] else {
            fatalError("invalid response type, \(responseString)")
        }
        
        guard let userAgent = json["user-agent"] else {
            fatalError("no user-agent field in response, \(json)")
        }
        XCTAssertTrue(userAgent.hasPrefix("curl/"))
        
    }
    
    func testCustomUserAgent() {
        
        let url = "http://httpbin.org/user-agent"
        
        let response: HTTPClient.Response
        
        let myUserAgent = "mycustom-useragent-abc123"
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url, headers: [("User-Agent", myUserAgent)])
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        let responseString = String(data: response.body, encoding: .utf8)!
        
        print(responseString)
        
        XCTAssertTrue(responseString.contains("user-agent"))
        XCTAssertTrue(responseString.contains(myUserAgent))
    }
    
    
    func testEffectiveURL() throws {
        
        let url = "http://httpbin.org/redirect/2"
        
        let response = try HTTPClient.sendRequest(method: "GET", url: url)
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        let responseString = String(data: response.body, encoding: .utf8)!
        
        print(responseString)
        XCTAssertEqual(response.effectiveURL, "http://httpbin.org/get")
    }
    
    func testFetchLargeFile() throws {
        
        let url = "https://swift.org/builds/swift-3.1.1-release/ubuntu1610/swift-3.1.1-RELEASE/swift-3.1.1-RELEASE-ubuntu16.10.tar.gz"
        
        let response: HTTPClient.Response
        
        do {
            var option = HTTPClient.Option()
            option.timeoutInterval = 180
            response = try HTTPClient.sendRequest(method: "GET", url: url, option: option)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        XCTAssertTrue(containsInHeader(response.headers, key: "Content-Type", valueContains: "application/x-gzip"))
        
        print("response body size:", response.body.count)
        
        // TODO: verify checksum
        XCTAssertEqual(response.body.count, 122736672)
        
    }
    
    func testGzippedResponse() throws {
        
        let url = "https://httpbin.org/gzip"
        
        let response: HTTPClient.Response
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let json = try JSONSerialization.jsonObject(with: response.body)
        
        let isGzipped = (json as? [String: Any])?["gzipped"] as? Bool
        XCTAssertEqual(isGzipped, true)
    }
    
    // TODO: test
    /*func testStatusCodeViaProxy() {
        
        let url = "http://httpbin.org/status/200"
        
        var response: HTTPClient.Response!
        
        do {
            var option = HTTPClient.Option()
            option.proxy = "localhost:3128"
            response = try HTTPClient.sendRequest(method: "GET", url: url, option: option)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }*/
}
