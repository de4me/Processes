//
//  ProcessRecord.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


struct ProcessRecord {
    
    let id: NSManagedObjectID;
    let name: String;
    let identifier: String;
    let pid: pid_t;
    let date: Date;
    
    init(process: DBProcess) {
        self.id = process.objectID;
        self.name = process.name ?? "";
        self.identifier = process.identifier ?? "";
        self.date = process.date ?? Date();
        self.pid = process.pid;
    }
    
}


extension ProcessRecord: DatabaseObjectIDProtocol {
    
    func objectId() -> NSManagedObjectID {
        self.id;
    }
    
}
