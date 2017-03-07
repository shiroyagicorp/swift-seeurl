//
//  cURLReadFunction.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import CcURL

public extension cURL {
    
    public typealias ReadCallBack = curl_read_callback
    
    public static var ReadFunction: ReadCallBack { return curlReadFunction }
    
    public final class ReadFunctionStorage {
        
        public var data: [UInt8]
        
        public var currentIndex = 0
        
        public init(data: [UInt8]) {
            
            self.data = data
        }
    }
}

public func curlReadFunction(pointer: UnsafeMutablePointer<Int8>?, size: Int, nmemb: Int, readData: UnsafeMutableRawPointer?) -> Int {
    
    guard let pointer = pointer, let readData = readData else { return 0 }
    
    let storage = unsafeBitCast(readData, to: cURL.ReadFunctionStorage.self)
    
    let data = storage.data
    
    let currentIndex = storage.currentIndex
    
    guard (size * nmemb) > 0 else { return 0 }
    
    guard currentIndex < data.count else { return 0 }
    
    let byte = data[currentIndex]
    
    let char = CChar(byte)
    
    pointer.pointee = char
    
    storage.currentIndex += 1
    
    return 1
}

