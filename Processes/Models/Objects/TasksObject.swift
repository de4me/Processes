//
//  TasksObject.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class TasksObject: NSObject {
    
    @IBOutlet var preferences: TaskViewPreferences!;
    @IBOutlet var errorObject: ErrorObject!;
    
    @objc dynamic private(set) var applications: [NSRunningApplication];
    @objc dynamic var selectionIndexes: IndexSet;
    
    private var database: sDatabase;
    private var timer: Timer?;
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override init() {
        self.applications = [];
        self.selectionIndexes = [];
        self.database = sDatabase.shared;
    }
    
    @objc func refresh() {
        self.applications = NSWorkspace.shared.runningApplications;
    }
    
    private func saveHandler(_ result: Error?) {
        guard let result else {
            return
        }
        self.errorObject.error = result;
    }
    
    @objc func save() {
        self.database.save(applications: self.applications, completionHandler: self.saveHandler);
    }
    
    @objc private func timerHandler(_ timer: Timer) {
        self.refresh();
    }
    
    private func refreshIntervalChanged(_ object: TaskViewPreferences, _ change: NSKeyValueObservedChange<TimeInterval>) {
        self.timer?.invalidate();
        guard let interval = change.newValue,
              interval > 0
        else {
            self.timer = nil;
            return;
        }
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.timerHandler(_:)), userInfo: nil, repeats: true);
    }
    
}


extension TasksObject: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.preferences.observe(\.refreshInterval, options: [.initial, .new], changeHandler: self.refreshIntervalChanged)
        ]
    }
    
    func registerObservers() -> [NSKeyValueObservation] {
        self.makeArray();
    }
    
}


extension TasksObject: TimerProtocol {
    
    func startTimers() {
        
    }
    
    func stopTimers() {
        self.timer?.invalidate();
        self.timer = nil;
    }
    
}
