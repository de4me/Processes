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
    @IBOutlet var tasksArrayController: NSArrayController!;
    
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
    
    @objc func saveDocument(_ sender: Any?) {
        self.tasksObject.save();
    }
    
    @IBAction func taskInfoClick(_ sender: Any?) {
        self.performSegue(withIdentifier: SegueName.TaskInfo, sender: sender);
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.destinationController {
        case let controller as NSWindowController where segue.identifier == SegueName.TaskInfo:
            controller.contentViewController?.representedObject = self.tasksArrayController.selection;
            break;
        default:
            break;
        }
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
            self.errorObject.observe(\.error, options: [.initial, .new], changeHandler: self.errorChanged)
        ]
    }
    
    func registerObservers() -> [NSKeyValueObservation] {
        self.makeArray() +
        self.tasksObject.registerObservers()
    }
    
}
