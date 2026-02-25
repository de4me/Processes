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
    
    @objc dynamic private(set) var applications: [ApplicationObject];
    @objc dynamic var selectedApplication: ApplicationObject?;
    
    internal var observationArray: [NSKeyValueObservation];
    private var database: sDatabase;
    private var timer: Timer?;
    
    var count: Int {
        self.applications.count;
    }
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override init() {
        self.applications = [];
        self.observationArray = [];
        self.database = sDatabase.shared;
    }
    
    private func refreshed() -> [ApplicationObject] {
        let sort = self.preferences.sort;
        let tasks = NSWorkspace.shared.runningApplications;
        let applications = tasks.map { ApplicationObject(runningApplication: $0) }
        return applications.sorted(by: sort);
    }
    
    func refresh() {
        self.applications = self.refreshed();
    }
    
    private func saveHandler(_ result: Error?) {
        guard let result else {
            return
        }
        self.errorObject.error = result;
    }
    
    func save() {
        self.database.save(applications: self.applications, completionHandler: self.saveHandler);
    }
    
    subscript (_ index: Int) -> ApplicationObject {
        self.applications[index];
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
    
    private func sortChanged(_ object: TaskViewPreferences, _ change: NSKeyValueObservedChange<SortObject>) {
        guard let sort = change.newValue else {
            return;
        }
        self.applications = self.applications.sorted(by: sort);
    }
    
}


extension TasksObject: ObjectValueProtocol {
    
    func objectValue(for column: SortColumnName, at row: Int) -> Any? {
        let task = self.applications[row];
        switch column {
        case .name:
            return task.name;
        case .pid:
            return task.pid;
        case .indentifier:
            return task.identifier;
        case .date:
            return DateFormatter.localizedString(from: task.date, dateStyle: .short, timeStyle: .short);
        }
    }
    
}


extension TasksObject: ObserverProtocol {
    
    private func makeArray() -> [NSKeyValueObservation] {
        [
            self.preferences.observe(\.refreshInterval, options: [.initial, .new], changeHandler: self.refreshIntervalChanged),
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


extension TasksObject: TimerProtocol {
    
    func startTimers() {
        
    }
    
    func stopTimers() {
        self.timer?.invalidate();
        self.timer = nil;
    }
    
}
