//
//  SessionsObject.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;
import CoreData;


class SessionsObject: NSObject {
    
    @IBOutlet var errorObject: ErrorObject!;
    
    private var database: sDatabase;
    private var fetchController: NSFetchedResultsController<DBSession>;
    
    @objc dynamic var session: SessionRecord?;
    
    @IBOutlet var delegate: NSFetchedResultsControllerDelegate? {
        set {
            self.fetchController.delegate = newValue;
        }
        get {
            self.fetchController.delegate;
        }
    }
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override init() {
        self.database = sDatabase.shared;
        let sortdesc = NSSortDescriptor(key: #keyPath(DBSession.date), ascending: false);
        let request = DBSession.fetchRequest();
        request.sortDescriptors = [sortdesc];
        self.fetchController = NSFetchedResultsController<DBSession>(fetchRequest: request, managedObjectContext: self.database.mainContext, sectionNameKeyPath: nil, cacheName: nil);
        super.init();
        self.fetch();
    }
    
    private func fetch() {
        do {
            try self.fetchController.performFetchAndNotify();
        }
        catch {
            self.errorObject.error = error;
        }
    }
    
    private func deleteHandler(_ result: Error?) {
        if let result {
            self.errorObject.error = result;
            return;
        }
        self.session = nil;
    }
    
    func delete() {
        guard let session = self.session else {
            return;
        }
        sDatabase.shared.delete(objects: [session], completionHandler: self.deleteHandler);
    }
    
    private func clearHandler(_ result: Error?) {
        if let result {
            self.errorObject.error = result;
            return;
        }
        self.session = nil;
    }
    
    func clear() {
        self.database.clear(self.clearHandler);
    }
    
    subscript (row: Int) -> SessionRecord? {
        guard let session = self.fetchController.fetchedObjects?[row] else {
            return nil;
        }
        return SessionRecord(session: session);
    }
    
    var count: Int {
        self.fetchController.fetchedObjects?.count ?? 0;
    }
    
    func firstIndex(of session: SessionRecord) -> Int? {
        self.fetchController.fetchedObjects?.firstIndex(where: {$0.objectID == session.objectId()} )
    }
    
}


extension SessionsObject: ObjectValueProtocol {
    
    func objectValue(for column: SortColumnName, at row: Int) -> Any? {
        guard let session = self[row] else {
            return nil;
        }
        return session.title;
    }
    
}


extension SessionsObject: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            
        ]
    }
    
    func registerObservers() -> [NSKeyValueObservation] {
        self.makeArray();
    }
    
}
