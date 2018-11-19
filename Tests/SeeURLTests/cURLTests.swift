//
//  cURLTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//  Copyright © 2016 Shiroyagi Corporation. All rights reserved.
//

import CcURL
import XCTest
import SeeURL
import Foundation

final class cURLTests: XCTestCase {
    
    // MARK: - Live Tests
    
    func testGetStatusCode() {
        
        let curl = cURL()
        
        let testStatusCode = 200
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        try! curl.set(option: CURLOPT_URL, "http://httpbin.org/status/\(testStatusCode)")
        
        try! curl.set(option: CURLOPT_TIMEOUT, 5)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode: cURL.Long = try! curl.get(info: CURLINFO_RESPONSE_CODE)
        
        XCTAssert(responseCode == testStatusCode, "\(responseCode) == \(testStatusCode)")
    }
    
    func testPostField() {
        
        let curl = cURL()
        
        let url = "http://httpbin.org/post"
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        try! curl.set(option: CURLOPT_URL, url)
        
        let effectiveURL = try! curl.get(info: CURLINFO_EFFECTIVE_URL) as String
        
        XCTAssert(url == effectiveURL)
        
        try! curl.set(option: CURLOPT_TIMEOUT, 10)
        
        try! curl.set(option: CURLOPT_POST, true)
        
        let data: [UInt8] = [0x54, 0x65, 0x73, 0x74] // "Test"
        
        try! curl.set(option: CURLOPT_POSTFIELDS, data)
        
        try! curl.set(option: CURLOPT_POSTFIELDSIZE, data.count)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.get(info: CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
    }
    
    func testReadFunction() {
        
        let curl = cURL()
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        try! curl.set(option: CURLOPT_URL, "http://httpbin.org/post")
        
        try! curl.set(option: CURLOPT_TIMEOUT, 10)
        
        try! curl.set(option: CURLOPT_POST, true)
        
        let data: [UInt8] = [0x54, 0x65, 0x73, 0x74] // "Test"
        
        try! curl.set(option: CURLOPT_POSTFIELDSIZE, data.count)
        
        let dataStorage = cURL.ReadFunctionStorage(data: data)
        
        try! curl.set(option: CURLOPT_READDATA, Unmanaged.passUnretained(dataStorage))
                
        try! curl.set(option: CURLOPT_READFUNCTION, curlReadFunction)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = (try! curl.get(info: CURLINFO_RESPONSE_CODE) as cURL.Long) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
    }
    
    func testWriteFunction() throws {
        
        let curl = cURL()
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        let url = "https://httpbin.org/image/jpeg"
        
        try! curl.set(option: CURLOPT_URL, url)
        
        try! curl.set(option: CURLOPT_TIMEOUT, 60)
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.set(option: CURLOPT_WRITEDATA, Unmanaged.passUnretained(storage))
        
        try! curl.set(option: CURLOPT_WRITEFUNCTION, cURL.WriteFunction)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.get(info: CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        #if swift(>=4.1)
        // workaround, TODO:
        // NSData(contentsOf: URL(string: url)!) not working???
        var fetchedWithFoundationData: NSData!
        let sema = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, resp, error) in
            fetchedWithFoundationData = NSData(data: data!)
            sema.signal()
        }
        task.resume()
        _ = sema.wait(timeout: .distantFuture)
        #else
        let fetchedWithFoundationData = try NSData(contentsOf: URL(string: url)!)
        #endif
        
        XCTAssert(storage.data == fetchedWithFoundationData)
    }
    
    func testHeaderWriteFunction() {
        
        let curl = cURL()
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        let url = "http://httpbin.org"
        
        try! curl.set(option: CURLOPT_URL, url)
        
        try! curl.set(option: CURLOPT_TIMEOUT, 5)
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.set(option: CURLOPT_HEADERDATA, Unmanaged.passUnretained(storage))
        
        try! curl.set(option: CURLOPT_HEADERFUNCTION, cURL.WriteFunction)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.get(info: CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        print("Header:\n\(String(data: Data(bytes: storage.data.bytes, count: storage.data.length) , encoding: .utf8)!)")
    }
    
    func testSetHeaderOption() {
        
        var curl: cURL! = cURL()
        
        try! curl.set(option: CURLOPT_VERBOSE, true)
        
        try! curl.set(option: CURLOPT_TIMEOUT, 10)
        
        let url = "http://httpbin.org/headers"
        
        try! curl.set(option: CURLOPT_URL, url)
        
        let header = "Header"
        
        let headerValue = "Value"
        
        try! curl.set(option: CURLOPT_HTTPHEADER, [header + ": " + headerValue])
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.set(option: CURLOPT_WRITEDATA, Unmanaged.passUnretained(storage))
        
        try! curl.set(option: CURLOPT_WRITEFUNCTION, curlWriteFunction)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.get(info: CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        print(String(data: Data(referencing: storage.data), encoding: .utf8)!)
        /*guard let jsonString = String.fromCString(storage.data),
            let jsonValue = JSON.Value(string: jsonString),
            let jsonObject = jsonValue.objectValue,
            let jsonHeaders = jsonObject["headers"]?.objectValue,
            let jsonHeaderValue = jsonHeaders[header]?.rawValue as? String
            else { XCTFail("Invalid JSON response: \(String.fromCString(storage.data))"); return }
        
        XCTAssert(jsonHeaderValue == headerValue)
         */
        
        // invoke deinit
        curl = nil
    }
}
