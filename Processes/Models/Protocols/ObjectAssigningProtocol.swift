//
//  ObjectAssigningProtocol.swift
//  Processes
//
//  Created by DE4ME on 24.02.2026.
//

import Cocoa;


protocol ObjectAssigningProtocol {
    static func << (lhs: Self, rhs: Self);
}


extension ObjectAssigningProtocol where Self: NSObject & CodingKeysProtocol {
    
    static func << (lhs: Self, rhs: Self) {
        let keys = rhs.codingKeys();
        let paths = keys.map(\.stringValue);
        let dict = rhs.dictionaryWithValues(forKeys: paths);
        lhs.setValuesForKeys(dict);
    }
    
}
