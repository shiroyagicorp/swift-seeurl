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
        headerString = String.fromCString(data) ?? ""
    }
    func parse() -> [HTTPClient.Header] {
        let lines = headerString.splitCRorLF()
        return lines.map({ $0.splitByFirstColon() }).filter({ $0.count == 2})
            .map({ ($0[0], $0[1]) })
    }
}

extension String {
    func splitCRorLF() -> [String] {
        var lines: [ [Character] ] = []
        var cur: [Character] = []
        for c in self.characters {
            if c == "\r" || c == "\n" || c == "\r\n" {
                lines.append(cur)
                cur = []
            } else {
                cur.append(c)
            }
        }
        lines.append(cur)
        return lines.filter({ $0.count > 0}).map({ String($0) })
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
                value.append(c)
            }
        }
        // TODO: trim left
        if value.first == " " {
            value.removeFirst()
        }
        if name.count > 0 && value.count > 0 {
            return [String(name), String(value)]
        } else {
            return [self]
        }
    }
}
