//
//  vDatabaseProcessesViewController.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class vDatabaseProcessesViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    
    @IBOutlet var preferences: ProcessesViewPreferences!;
    @IBOutlet var processesDataSource: ProcessesDataSource!;
    @IBOutlet var processesObject: ProcessesObject!;
    @IBOutlet var errorObject: ErrorObject!;
    
    internal var observationArray: [NSKeyValueObservation] = [];
    
    override var representedObject: Any? {
        didSet {
            self.updateSession();
        }
    }

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
        self.preferences.load();
        self.registerObservers();
        self.processesObject.registerObservers();
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear();
        self.processesObject.unregisterObservers();
        self.unregisterObservers();
        self.preferences.save();
    }
    
    private func updateSession() {
        self.processesObject.session = self.representedObject as? SessionRecord;
    }
    
    @IBAction func deleteClick(_ sender: NSButton) {
        self.processesObject.delete();
    }
    
    func errorChanged(_ object: ErrorObject, _ change: NSKeyValueObservedChange<(any Error)?>) {
        guard let result = change.newValue as? Error  else {
            return;
        }
        self.showError(onMainThread: result);
    }
}


extension vDatabaseProcessesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.tableView.reloadData();
    }
    
}


extension vDatabaseProcessesViewController: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.processesObject.selectedRow = self.tableView.selectedRow;
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        guard let column = SortColumnName(columnIdentifier: tableColumn.identifier) else {
            return;
        }
        self.preferences.sortColumn = column;
    }
    
}


extension vDatabaseProcessesViewController: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.errorObject.observe(\.error, options: [.initial, .new], changeHandler: self.errorChanged)
        ]
    }
    
    internal func registerObservers() {
        self.observationArray = makeArray();
    }
    
    internal func unregisterObservers() {
        self.observationArray = [];
    }
    
}
