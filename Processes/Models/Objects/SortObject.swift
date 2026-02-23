//
//  SortObject.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


@objc final class SortObject: NSObject, Codable {

    let name: SortColumnName;
    let ascending: Bool;
    
    init(column: SortColumnName, ascending: Bool = true) {
        self.name = column;
        self.ascending = ascending;
    }

}


extension SortObject: ToggledProtocol {
    
    func toggled() -> Self {
        .init(column: self.name, ascending: !self.ascending);
    }
    
}

