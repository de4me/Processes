//
//  vCurrentViewController.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class vTasksViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!;
    
    @IBOutlet var tasksObject: TasksObject!;
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
        self.observationArray = self.registerObservers();
        self.tasksObject.startTimers();
        self.tasksObject.refresh();
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear();
        self.tasksObject.stopTimers();
        self.observationArray = [];
        self.preferences.save();
    }
    
    @IBAction func refreshClick(_ sender: Any?) {
        self.tasksObject.refresh();
    }
    
    @IBAction func saveDocument(_ sender: Any?) {
        self.tasksObject.save();
    }
    
    @IBAction func taskInfoClick(_ sender: Any?) {
        self.performSegue(withIdentifier: SegueName.TaskInfo, sender: sender);
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.destinationController {
        case let controller as NSWindowController where segue.identifier == SegueName.TaskInfo:
            controller.contentViewController?.representedObject = self.tasksObject.selectedApplication;
        default:
            break;
        }
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
            self.tasksObject.observe(\.applications, options: [.initial, .new], changeHandler: self.tasksChanged),
            self.errorObject.observe(\.error, options: [.initial, .new], changeHandler: self.errorChanged)
        ]
    }
    
    func registerObservers() -> [NSKeyValueObservation] {
        self.makeArray() +
        self.tasksObject.registerObservers()
    }
    
}


extension vTasksViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        guard let column = SortColumnName(columnIdentifier: tableColumn.identifier) else {
            return;
        }
        self.preferences.sortColumn = column;
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = self.tableView.selectedRow;
        guard row >= 0, row < self.tasksObject.count else {
            self.tasksObject.selectedApplication = nil;
            return;
        }
        self.tasksObject.selectedApplication = self.tasksObject[row];
    }
    
}
