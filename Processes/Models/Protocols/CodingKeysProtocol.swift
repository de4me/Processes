//
//  CodingKeysProtocol.swift
//  Processes
//
//  Created by DE4ME on 24.02.2026.
//

import Cocoa;


protocol CodingKeysProtocol {
    func codingKeys() -> [any CodingKey];
}


protocol CodingNameProtocol {
    func codingName() -> String;
}


extension CodingNameProtocol where Self: NSObject {
    
    func codingName() -> String {
        NSStringFromClass(type(of: self));
    }
    
}
