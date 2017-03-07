//
//  cURLStringList.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/5/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import CcURL

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