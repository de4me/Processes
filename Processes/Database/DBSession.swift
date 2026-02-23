//
//  DBSession.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import CoreData;


extension DBSession {
    
    convenience init(applications: [ApplicationObject], context: NSManagedObjectContext) {
        self.init(entity: DBSession.entity(), insertInto: context);
        self.date = Date();
        applications.forEach {
            let process = DBProcess(application: $0, context: context);
            self.addToTasks(process);
        }
    }
    
}
