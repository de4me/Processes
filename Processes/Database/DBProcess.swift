//
//  DBProcesses.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import CoreData;


extension DBProcess {
    
    convenience init(application: ApplicationObject, context: NSManagedObjectContext) {
        self.init(entity: DBProcess.entity(), insertInto: context);
        self.name = application.name;
        self.date = application.date;
        self.pid = application.pid;
        self.identifier = application.identifier;
        self.architecture = Int32(application.architecture);
        self.bundleURL = application.bundleURL.relativePath;
        self.executableURL = application.executableURL.relativePath;
    }
    
}


extension DBProcess: KeyNameProtocol {
    
    static func keyName(for column: SortColumnName) -> String? {
        switch column {
        case .name:
            return #keyPath(DBProcess.name);
        case .indentifier:
            return #keyPath(DBProcess.identifier);
        case .pid:
            return #keyPath(DBProcess.pid);
        case .date:
            return #keyPath(DBProcess.date);
        }
    }
    
}


extension NSFetchRequest where ResultType == DBProcess {
    
    func prepare(sort: SortObject) {
        guard let key = DBProcess.keyName(for: sort.name) else {
            return;
        }
        let descriptor = NSSortDescriptor(key: key, ascending: sort.ascending);
        self.sortDescriptors = [descriptor];
    }
    
}


extension NSFetchedResultsController<DBProcess> {
    
    func performFetchAndNotify() throws {
        self.delegate?.controllerWillChangeContent?(self as! NSFetchedResultsController<any NSFetchRequestResult>);
        try self.performFetch();
        self.delegate?.controllerDidChangeContent?(self as! NSFetchedResultsController<any NSFetchRequestResult>);
    }
    
}
