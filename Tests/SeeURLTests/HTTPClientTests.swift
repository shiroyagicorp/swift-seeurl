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
    
    func testResponseBody() {
        
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
        
        func hasContainsHeader(key: String, valueContains: String) -> Bool {
            for h in response.headers {
                if h.0 == key && h.1.contains(valueContains) {
                    return true
                }
            }
            return false
        }
        
        XCTAssertTrue(hasContainsHeader(key: "Content-Type", valueContains: "application/json"))
        
        XCTAssertTrue(responseString.contains("user-agent"))
        
        // TODO: implement user agent
        
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
}
