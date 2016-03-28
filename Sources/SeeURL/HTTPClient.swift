//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS)
    import cURL
#elseif os(Linux)
    import CcURL
#endif

/// Loads HTTP requests
public struct HTTPClient {
    
    public struct Options {
        let timeoutInterval: Int
        let verbose: Bool
        init() {
            self.timeoutInterval = 30
            self.verbose = false
        }
        public init(timeoutInterval: Int, varbose: Bool) {
            self.timeoutInterval = timeoutInterval
            self.verbose = varbose
        }
    }
    
    public typealias Header = (String, String)
    public typealias Response = (Int, [Header], [UInt8])
    
    public static func sendRequest(method: String, url: String, headers: [Header] = [], body: [UInt8] = [], options: Options = Options()) throws -> Response {
        
        let curl = cURL()
        
        try curl.setOption(CURLOPT_VERBOSE, options.verbose)
        
        try curl.setOption(CURLOPT_URL, url)
        
        try curl.setOption(CURLOPT_TIMEOUT, cURL.Long(options.timeoutInterval))
        
        // append data
        if body.count > 0 {
            
            try curl.setOption(CURLOPT_POSTFIELDS, body)
            
            try curl.setOption(CURLOPT_POSTFIELDSIZE, body.count)
        }
        
        // set HTTP method
        switch method.uppercased() {
            
        case "HEAD":
            try curl.setOption(CURLOPT_NOBODY, true)
            try curl.setOption(CURLOPT_CUSTOMREQUEST, "HEAD")
            
        case "POST":
            try curl.setOption(CURLOPT_POST, true)
            
        case "GET": try curl.setOption(CURLOPT_HTTPGET, true)
            
        default:
            
            try curl.setOption(CURLOPT_CUSTOMREQUEST, method.uppercased())
        }
        
        // set headers
        if headers.count > 0 {
            
            var curlHeaders = [String]()
            
            for header in headers {
                
                curlHeaders.append(header.0 + ": " + header.1)
            }
            
            try curl.setOption(CURLOPT_HTTPHEADER, curlHeaders)
        }
        
        // set response data callback
        
        let responseBodyStorage = cURL.WriteFunctionStorage()
        
        try! curl.setOption(CURLOPT_WRITEDATA, responseBodyStorage)
        
        try! curl.setOption(CURLOPT_WRITEFUNCTION, curlWriteFunction)
        
        let responseHeaderStorage = cURL.WriteFunctionStorage()
        
        try! curl.setOption(CURLOPT_HEADERDATA, responseHeaderStorage)
        
        try! curl.setOption(CURLOPT_HEADERFUNCTION, curlWriteFunction)
        
        // connect to server
        try curl.perform()
        
        let responseCode = try curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        let resHeaders = ResponseHeaderParser(data: unsafeBitCast(responseHeaderStorage.data, to: [CChar].self)).parse()
        
        let resBody = responseBodyStorage.data
        
        return (responseCode, resHeaders, resBody)
    }
    
    public enum Error: ErrorProtocol {
        
        /// The provided request was malformed.
        case BadRequest
    }
}

// MARK: - Linux Support

#if os(Linux)
    
    public let CURLOPT_WRITEDATA = CURLOPT_FILE
    public let CURLOPT_HEADERDATA = CURLOPT_WRITEHEADER
    public let CURLOPT_READDATA = CURLOPT_INFILE
    public let CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER
    
#endif

