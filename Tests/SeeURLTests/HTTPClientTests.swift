//
//  HTTPClientTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//  Copyright © 2016 Shiroyagi Corporation. All rights reserved.
//

import CcURL
import XCTest
import SeeURL
import Foundation

extension HTTPClientTests {
    static var allTests : [(String, (HTTPClientTests) -> () throws -> Void)] {
        return [
            ("testStatusCode", testStatusCode),
            ("testSSLStatusCode", testSSLStatusCode),
            ("testResponseBody", testResponseBody),
            ("testCustomUserAgent", testCustomUserAgent),
            ("testEffectiveURL", testEffectiveURL)
        ]
    }
}

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
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testSSLStatusCode() {
        
        let url = "https://httpbin.org/status/200"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testResponseBody() throws {
        
        let url = "http://httpbin.org/user-agent"
        
        var response: HTTPClient.Response!
        
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
        
        var response: HTTPClient.Response!
        
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
        
        let url = "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/dists/xenial/Contents-amd64.gz"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        XCTAssertTrue(containsInHeader(response.headers, key: "Content-Type", valueContains: "application/x-gzip"))
        
        print("response body size:", response.body.count)
        
        XCTAssertEqual(response.body.count, 33251183)
        
    }
}
