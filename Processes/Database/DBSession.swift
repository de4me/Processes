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
        let date = Date();
        self.date = date;
        self.title = "";
        let process = ProcessInfo.processInfo;
        self.systemUptime = Double(process.systemUptime);
        self.operatingSystemVersion = String(osVersion: process.operatingSystemVersion);
        self.locked = false;
        applications.forEach {
            let process = DBProcess(application: $0, context: context);
            self.addToTasks(process);
        }
    }
    
}


extension NSFetchedResultsController<DBSession> {
    
    func performFetchAndNotify() throws {
        self.delegate?.controllerWillChangeContent?(self as! NSFetchedResultsController<any NSFetchRequestResult>);
        try self.performFetch();
        self.delegate?.controllerDidChangeContent?(self as! NSFetchedResultsController<any NSFetchRequestResult>);
    }
    
}
