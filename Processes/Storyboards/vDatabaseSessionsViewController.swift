//
//  vDatabaseSessionsViewController.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;
import CoreData;


class vDatabaseSessionsViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!;
    
    @IBOutlet var sessionsObject: SessionsObject!;
    @IBOutlet var sessionsDataSource: SessionsDataSource!;
    @IBOutlet var errorObject: ErrorObject!;
    
    internal var observationArray: [NSKeyValueObservation] = [];
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        self.registerObservers();
        self.sessionsObject.registerObservers();
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear();
        self.sessionsObject.unregisterObservers();
        self.unregisterObservers();
    }
    
    private func updateSelectedRow() {
        let row = self.tableView.selectedRow;
        guard row >= 0, row < self.sessionsObject.count else {
            self.sessionsObject.session = nil;
            return;
        }
        let session = self.sessionsObject[row];
        if let session, let current = self.sessionsObject.session, session.same(current) {
            return;
        }
        self.sessionsObject.session = session
    }
    
    @IBAction func deleteClick(_ sender: Any?) {
        self.sessionsObject.delete();
    }
    
    @IBAction func clearClick(_ sender: Any?) {
        self.sessionsObject.clear();
    }
    
    private func sessionChanged(_ object: SessionsObject, _ change: NSKeyValueObservedChange<SessionRecord?> ) {
        OperationQueue.main.addOperation {
            guard let controller = self.splitViewController(of: vDatabaseProcessesViewController.self) else {
                return;
            }
            if let session = change.newValue as? SessionRecord {
                controller.representedObject = session;
            } else {
                self.updateSelectedRow();
            }
        }
    }
    
    private func errorChanged(_ object: ErrorObject, _ change: NSKeyValueObservedChange<(any Error)?>) {
        guard let result = change.newValue as? Error else {
            return;
        }
        self.showError(onMainThread: result);
    }
}


extension vDatabaseSessionsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.tableView.reloadData();
        guard let session = self.sessionsObject.session,
              let row = self.sessionsObject.firstIndex(of: session)
        else {
            return;
        }
        self.tableView.selectRowIndexes(.init(integer: row), byExtendingSelection: false);
    }
    
}


extension vDatabaseSessionsViewController: NSTableViewDelegate {
    
    internal func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateSelectedRow();
    }
    
}


extension vDatabaseSessionsViewController: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.sessionsObject.observe(\.session, options: [.new], changeHandler: self.sessionChanged),
            self.errorObject.observe(\.error, options: [.new], changeHandler: self.errorChanged),
        ]
    }
    
    internal func registerObservers() {
        self.observationArray = makeArray();
    }
    
    internal func unregisterObservers() {
        self.observationArray = [];
    }

}
