//
//  ProcessesObject.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;
import CoreData;


class ProcessesObject: NSObject {
    
    @IBOutlet var preferences: ProcessesViewPreferences!;
    @IBOutlet var errorObject: ErrorObject!;
    
    private let database: sDatabase;
    private var fetchController: NSFetchedResultsController<DBProcess>;
    
    @objc dynamic var process: ProcessRecord?;
    @objc dynamic var session: SessionRecord?;
    
    var hasSession: Bool {
        self.session != nil;
    }
    
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
        let sortdesc = NSSortDescriptor(key: #keyPath(DBProcess.name), ascending: true);
        let request = DBProcess.fetchRequest();
        request.sortDescriptors = [sortdesc];
        self.fetchController = NSFetchedResultsController<DBProcess>(fetchRequest: request, managedObjectContext: self.database.mainContext, sectionNameKeyPath: nil, cacheName: nil);
        super.init();
    }

    private func fetch(session: SessionRecord) {
        do {
            self.fetchController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(DBProcess.session), session.id);
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
        self.process = nil;
    }
    
    func delete() {
        guard let process = self.process else {
            return;
        }
        sDatabase.shared.delete(objects: [process], completionHandler: self.deleteHandler);
    }
    
    subscript (row: Int) -> ProcessRecord? {
        guard let process = self.fetchController.fetchedObjects?[row] else {
            return nil;
        }
        return ProcessRecord(process: process);
    }
    
    var count: Int {
        self.fetchController.fetchedObjects?.count ?? 0;
    }
    
    func firstIndex(of process: ProcessRecord) -> Int? {
        self.fetchController.fetchedObjects?.firstIndex(where: {$0.objectID == process.objectId()});
    }
    
    private func sortChanged(_ object: ProcessesViewPreferences, _ change: NSKeyValueObservedChange<SortObject>) {
        do {
            guard let sort = change.newValue else {
                return;
            }
            self.fetchController.fetchRequest.prepare(sort: sort);
            guard hasSession else {
                return;
            }
            try self.fetchController.performFetchAndNotify();
        }
        catch {
            self.errorObject.error = error;
        }
    }
    
    private func sessionChanged(_ object: ProcessesObject, _ change: NSKeyValueObservedChange<SessionRecord?>) {
        guard let session = change.newValue as? SessionRecord else {
            return;
        }
        self.fetch(session: session);
    }
    
}


extension ProcessesObject: ObjectValueProtocol {
    
    func objectValue(for column: SortColumnName, at row: Int) -> Any? {
        guard let session = self[row] else {
            return nil;
        }
        switch column {
        case .name:
            return session.name;
        case .pid:
            return session.pid;
        case .indentifier:
            return session.identifier;
        case .date:
            return DateFormatter.localizedString(from: session.date, dateStyle: .short, timeStyle: .medium);
        }
    }
    
}


extension ProcessesObject: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.preferences.observe(\.sort, options: [.initial, .new], changeHandler: self.sortChanged),
            self.observe(\.session, options: [.initial, .new], changeHandler: self.sessionChanged)
        ]
    }
    
    func registerObservers() -> [NSKeyValueObservation] {
        self.makeArray();
    }
    
}
