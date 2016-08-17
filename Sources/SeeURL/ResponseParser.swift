//
//  ResponseParser.swift
//  SeeURL
//
//  Created by ito on 2/20/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

struct ResponseHeaderParser {
    let headerString: String
    init(data: [CChar]) {
        //print("parsing header0", data)
        headerString = String(validatingUTF8: data) ?? ""
    }
    func parse() -> [HTTPClient.Header] {
        //print("parsing header1", headerString)
        let lines = headerString.splitCRorLF()
        //print("parsing header2", lines)
        return lines.map({ $0.splitByFirstColon() }).filter({ $0.count == 2})
            .map({ ($0[0], $0[1]) })
    }
}

extension String {
    func splitCRorLF() -> [String] {
        let part = self.characters.split(whereSeparator: { $0 == Character("\r") || $0 == Character("\n") || $0 == Character("\r\n") })
        return part.filter({ $0.count > 0 }).map(String.init)
    }
    func splitByFirstColon() -> [String] {
        var modeIsName: Bool = true
        var name: [Character] = []
        var value: [Character] = []
        for c in self.characters {
            if modeIsName && c == ":" {
                modeIsName = false
                continue
            }
            if modeIsName {
                name.append(c)
            } else {
                // trim left " " of value
                if value.count == 0 && c == " " {
                    // skip
                } else {
                    value.append(c)
                }
            }
        }
        if name.count > 0 && value.count > 0 {
            return [String(name), String(value)]
        } else {
            return [self]
        }
    }
}
