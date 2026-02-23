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
    
    internal var observationArray: [NSKeyValueObservation]
    
    @objc dynamic var selectedRow: Int;
    
    var session: SessionRecord? {
        didSet {
            guard let session = self.session else {
                return;
            }
            self.fetch(session: session);
        }
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
        self.selectedRow = -1;
        self.observationArray = [];
        self.database = sDatabase.shared;
        let sortdesc = NSSortDescriptor(key: #keyPath(DBProcess.name), ascending: true);
        let request = DBProcess.fetchRequest();
        request.sortDescriptors = [sortdesc];
        self.fetchController = NSFetchedResultsController<DBProcess>(fetchRequest: request, managedObjectContext: self.database.mainContext, sectionNameKeyPath: nil, cacheName: nil);
        super.init();
    }

    func fetch(session: SessionRecord) {
        do {
            self.fetchController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(DBProcess.session), session.id);
            try self.fetchController.performFetch();
        }
        catch {
            self.errorObject.error = error;
        }
    }
    
    private func deleteHandler(_ result: Error?) {
        guard let result else {
            return;
        }
        self.errorObject.error = result;
    }
    
    func delete() {
        let index = self.selectedRow
        guard index >= 0, index < self.count,
            let process = self[index]
        else {
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
    
    private func sortChanged(_ object: ProcessesViewPreferences, _ change: NSKeyValueObservedChange<SortObject>) {
        do {
            guard let sort = change.newValue else {
                return;
            }
            self.fetchController.fetchRequest.prepare(sort: sort);
            try self.fetchController.performFetch();
        }
        catch {
            self.errorObject.error = error;
        }
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
            self.preferences.observe(\.sort, options: [.initial, .new], changeHandler: self.sortChanged)
        ]
    }
    
    internal func registerObservers() {
        self.observationArray = makeArray();
    }
    
    internal func unregisterObservers() {
        self.observationArray = [];
    }
    
}
