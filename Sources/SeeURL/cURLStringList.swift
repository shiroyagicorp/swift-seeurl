//
//  cURLStringList.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/5/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS)
    import cURL
#elseif os(Linux)
    import CcURL
#endif

public extension cURL.StringList {
    
    init(strings: [String]) {
        
        self = curl_slist()
        
        for string in strings {
            
            self.append(string: string)
        }
    }
    
    var value: String? { return String(validatingUTF8: data) }
    
    mutating func append(string: String) { curl_slist_append(&self, string) }
    
    mutating func free() { curl_slist_free_all(&self) }
}