//
//  KeyNameProtocol.swift
//  Processes
//
//  Created by DE4ME on 23.02.2026.
//

import CoreData;


protocol KeyNameProtocol: NSManagedObject {
    
    static func keyName(for column: SortColumnName) -> String?;
    
}
