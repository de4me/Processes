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
    
    @IBAction func deleteClick(_ sender: Any?) {
        self.sessionsObject.delete();
    }
    
    @IBAction func clearClick(_ sender: Any?) {
        self.sessionsObject.clear();
    }
    
    func selectionChanged(_ object: SessionsObject, _ change: NSKeyValueObservedChange<Int> ) {
        guard let row = change.newValue,
              row >= 0, row < self.sessionsObject.count,
              let session = self.sessionsObject[row],
              let controller = self.splitViewController(of: vDatabaseProcessesViewController.self)
        else {
            return;
        }
        controller.representedObject = session;
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
    }
    
}


extension vDatabaseSessionsViewController: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.sessionsObject.selectedRow = self.tableView.selectedRow;
    }
    
}


extension vDatabaseSessionsViewController: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.sessionsObject.observe(\.selectedRow, options: [.new], changeHandler: self.selectionChanged),
            self.errorObject.observe(\.error, options: [.initial, .new], changeHandler: self.errorChanged),
        ]
    }
    
    internal func registerObservers() {
        self.observationArray = makeArray();
    }
    
    internal func unregisterObservers() {
        self.observationArray = [];
    }

}
