//
//  HTTPClientTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS)
    import cURL
#elseif os(Linux)
    import CcURL
#endif

import XCTest
import SeeURL
import Foundation

extension HTTPClientTests {
    static var allTests : [(String, (HTTPClientTests) -> () throws -> Void)] {
        return [
            ("testStatusCode", testStatusCode),
            ("testSSLStatusCode", testSSLStatusCode),
            ("testResponseBody", testResponseBody)
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
        
        let statusCode = response.0
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testSSLStatusCode() {
        
        let url = "https://httpbin.org/status/200"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.0
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testResponseBody() {
        
        let url = "http://httpbin.org/user-agent"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest(method: "GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.0
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        let responseString = String(cString: unsafeBitCast(response.2, to: [CChar].self))

        print(response.1)
        
        XCTAssertEqual(response.1[0].0, "Server")
        XCTAssertEqual(response.1[0].1, "nginx")
        
        XCTAssertTrue(responseString.contains("user-agent"))
        
        // TODO: implement user agent
        
    }
}
