//
//  ProcessRecord.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class ProcessRecord: NSObject {
    
    let id: NSManagedObjectID;
    let name: String;
    let identifier: String;
    let pid: pid_t;
    let date: Date;
    let architecture: Int;
    let bundleURL: URL;
    let executableURL: URL;
    
    init(process: DBProcess) {
        self.id = process.objectID;
        self.name = process.name ?? "";
        self.identifier = process.identifier ?? "";
        self.date = process.date ?? Date();
        self.pid = process.pid;
        self.architecture = Int(process.architecture);
        self.bundleURL = process.bundleURL != nil ? URL(fileURLWithPath: process.bundleURL!) : URL.rootURL;
        self.executableURL = process.executableURL != nil ? URL(fileURLWithPath: process.executableURL!) : URL.rootURL;
    }
    
    func same(_ process: ProcessRecord) -> Bool {
        self.objectId() == process.objectId();
    }
    
}


extension ProcessRecord: DatabaseObjectIDProtocol {
    
    func objectId() -> NSManagedObjectID {
        self.id;
    }
    
}
