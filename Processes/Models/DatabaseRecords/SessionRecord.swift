//
//  SessionRecord.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import CoreData;


class SessionRecord: NSObject {
    
    let id: NSManagedObjectID;
    let date: Date;
    let title: String;
    let systemUptime: TimeInterval;
    let operatingSystemVersion: String;
    let locked: Bool;
    
    init(session: DBSession) {
        self.id = session.objectID;
        let date = session.date ?? Date();
        self.date = date;
        self.title = session.title ?? "";
        self.systemUptime = session.systemUptime;
        self.operatingSystemVersion = session.operatingSystemVersion ?? "";
        self.locked = session.locked;
    }
    
    func same(_ session: SessionRecord) -> Bool {
        self.objectId() == session.objectId();
    }
    
}


extension SessionRecord: ObjectIDProtocol {
    
    func objectId() -> NSManagedObjectID {
        self.id;
    }
    
}
