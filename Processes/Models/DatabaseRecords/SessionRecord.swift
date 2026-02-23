//
//  SessionRecord.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import CoreData;


struct SessionRecord {
    
    let id: NSManagedObjectID;
    let date: Date;
    
    var title: String {
        DateFormatter.localizedString(from: self.date, dateStyle: .short, timeStyle: .short);
    }
    
    init(session: DBSession) {
        self.id = session.objectID;
        self.date = session.date ?? Date();
    }
    
}


extension SessionRecord: DatabaseObjectIDProtocol {
    
    func objectId() -> NSManagedObjectID {
        self.id;
    }
    
}
