//
//  vCurrentViewController.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class vTasksViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!;
    
    @IBOutlet var runningApplications: TasksObject!;
    @IBOutlet var preferences: TaskViewPreferences!;
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
        self.preferences.load();
        self.registerObservers();
        self.runningApplications.registerObservers();
        self.runningApplications.startTimers();
        self.runningApplications.refresh();
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear();
        self.runningApplications.stopTimers();
        self.runningApplications.unregisterObservers();
        self.unregisterObservers();
        self.preferences.save();
    }
    
    @IBAction func refreshClick(_ sender: Any?) {
        self.runningApplications.refresh();
    }
    
    @IBAction func saveDocument(_ sender: Any?) {
        self.runningApplications.save();
    }
    
    private func tasksChanged(_ dataSource: TasksObject, change: NSKeyValueObservedChange<[ApplicationObject]>) {
        self.tableView.reloadData();
    }
    
    private func errorChanged(_ object: ErrorObject, _ change: NSKeyValueObservedChange<(any Error)?>) {
        guard let error = change.newValue as? Error else {
            return;
        }
        self.showError(onMainThread: error);
    }
    
}


extension vTasksViewController: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.runningApplications.observe(\.applications, options: [.initial, .new], changeHandler: self.tasksChanged),
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


extension vTasksViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        guard let column = SortColumnName(columnIdentifier: tableColumn.identifier) else {
            return;
        }
        self.preferences.sortColumn = column;
    }
    
}
