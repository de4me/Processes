//
//  SortColumnName.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


enum SortColumnName: NSString, Codable {
    case name;
    case indentifier;
    case date;
    case pid;
}


extension SortColumnName {
    
    init?(columnIdentifier: NSUserInterfaceItemIdentifier) {
        guard let column = SortColumnName(rawValue: columnIdentifier.rawValue as NSString) else {
            return nil;
        }
        self = column;
    }
}

