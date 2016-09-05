//
//  cURL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/1/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS)
    import cURL
#elseif os(Linux)
    import CcURL
#endif

/// Class that encapsulates cURL handler.
public final class cURL {
    
    // MARK: - Typealiases
    
    public typealias Long = CLong
    
    public typealias Handler = UnsafeMutableRawPointer
    
    public typealias Option = CURLoption
    
    public typealias Info = CURLINFO
    
    public typealias StringList = curl_slist
    
    // MARK: - Properties
    
    /// Private pointer to ```cURL.Handler```.
    private let internalHandler: Handler
    
    /// Private pointer to
    private var internalOptionStringLists: [Option.RawValue: UnsafeMutablePointer<StringList>?] = [:]
    
    // MARK: - Initialization
    
    deinit {
        
        // free string lists
        for (_, pointer) in self.internalOptionStringLists {
            
            if let pointer = pointer {
                
                pointer.pointee.free()
                
                pointer.deinitialize()
            }
        }
        
        curl_easy_cleanup(internalHandler)
    }
    
    public init() {
        
        internalHandler = curl_easy_init()
    }
    
    private init(handler: Handler) {
        
        self.internalHandler = handler
    }
    
    // MARK: - Methods
    
    /// Resets the state of the receiver.
    ///
    /// Re-initializes the internal ```CURL``` handle to the default values.
    /// This puts back the handle to the same state as it was in when it was just created.
    ///
    /// - Note: It does keep: live connections, the Session ID cache, the DNS cache and the cookies.
    ///
    public func reset() {
        
        curl_easy_reset(internalHandler)
    }
    
    /// Executes the request. 
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        guard code.rawValue == CURLE_OK.rawValue  else { throw Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    // MARK: - Set Option
    
    public func set(option: Option, _ value: String) throws {
        
        let code = curl_easy_setopt_string(internalHandler, option, value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    public func set(option: Option, _ value: [UInt8]) throws {
        
        let code = curl_easy_setopt_string(internalHandler, option, unsafeBitCast(value, to: [Int8].self))
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    public func set(option: Option, _ value: @escaping curl_read_callback) throws {
        
        let code = curl_easy_setopt_func(internalHandler, option, value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    public func set(option: Option, _ value: AnyObject) throws {
        
        let code = curl_easy_setopt_pointer(internalHandler, option, unsafeBitCast(value, to: UnsafeMutableRawPointer.self))
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    public func set(option: Option, _ value: inout [Int8]) throws {
        
        let code = curl_easy_setopt_pointer(internalHandler, option, &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    /// Set ```cURL.Long``` value for ```CURLoption```.
    public func set(option: Option, _ value: Long) throws {
        
        let code = curl_easy_setopt_long(internalHandler, option, value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    /// Set boolean value for ```CURLoption```.
    public func set(option: Option, _ value: Bool) throws {
        
        let code = curl_easy_setopt_bool(internalHandler, option, value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
    }
    
    /// Set string list value for ```CURLoption```.
    public func set(option: Option, _ value: [String]) throws {
        
        // will dealloc in deinit
        var pointer: UnsafeMutablePointer<StringList>? = nil
        
        for string in value {
            
            pointer = curl_slist_append(pointer, string)
        }
        
        let code = curl_easy_setopt_slist(internalHandler, option, pointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
        
        internalOptionStringLists[option.rawValue] = pointer
    }
    
    // MARK: Get Info
    
    /// Get string value for ```CURLINFO```.
    public func get(info: Info) throws -> String {
        
        var stringBytesPointer: UnsafePointer<CChar>? = nil
        
        let code = curl_easy_getinfo_string(internalHandler, info, &stringBytesPointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
        
        guard let strPtr = stringBytesPointer else {
            return ""
        }
        return String(validatingUTF8: strPtr) ?? ""
    }
    
    /// Get ```Long``` value for ```CURLINFO```.
    public func get(info: Info) throws -> Long {
        
        var value: Long = 0
        
        let code = curl_easy_getinfo_long(internalHandler, info, &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
        
        return value
    }
    
    /// Get ```Double``` value for ```CURLINFO```.
    public func get(info: Info) throws -> Double {
        
        var value: Double = 0
        
        let code = curl_easy_getinfo_double(internalHandler, info, &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw cURL.Error(rawValue: code.rawValue) ?? Error.Undefined }
        
        return value
    }
}

// MARK: - Function Declarations

//@asmname("curl_easy_setopt") public func curl_easy_setopt(curl: cURL.Handler, option: cURL.Option, param: UnsafePointer<UInt8>) -> CURLcode

//@asmname("curl_easy_getinfo") public func curl_easy_getinfo<T>(curl: cURL.Handler, info: cURL.Info, inout param: T) -> CURLcode


