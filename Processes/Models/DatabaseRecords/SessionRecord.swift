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
    
    var title: String {
        DateFormatter.localizedString(from: self.date, dateStyle: .short, timeStyle: .short);
    }
    
    init(session: DBSession) {
        self.id = session.objectID;
        self.date = session.date ?? Date();
    }
    
    func same(_ session: SessionRecord) -> Bool {
        self.objectId() == session.objectId();
    }
    
}


extension SessionRecord: DatabaseObjectIDProtocol {
    
    func objectId() -> NSManagedObjectID {
        self.id;
    }
    
}
