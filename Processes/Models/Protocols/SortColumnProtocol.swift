//
//  SortColumnProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


@objc protocol SortColumnObjectProtocol {
    @objc dynamic var sort: SortObject {set get};
}


protocol SortColumnProtocol: SortColumnObjectProtocol {
    var sortColumn: SortColumnName {get set};
}


extension SortColumnProtocol {
    
    var sortColumn: SortColumnName {
        get {
            self.sort.name;
        }
        set {
            if self.sort.name == newValue {
                self.sort = self.sort.toggled();
            } else {
                self.sort = .init(column: newValue);
            }
        }
    }
    
}
