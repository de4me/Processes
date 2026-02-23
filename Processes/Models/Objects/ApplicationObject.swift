//
//  RunningTask.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;



class ApplicationObject: NSObject, Codable {
    
    let name: String;
    let identifier: String;
    let pid: pid_t;
    let date: Date;
    
    init(name: String?, identifier: String?, pid: pid_t, date: Date?) {
        self.name = name ?? "";
        self.identifier = identifier ?? "";
        self.pid = pid
        self.date = date ?? Date();
    }
}


extension ApplicationObject {
    
    convenience init(runningApplication: NSRunningApplication) {
        self.init(name: runningApplication.localizedName, identifier: runningApplication.bundleIdentifier, pid: runningApplication.processIdentifier, date: runningApplication.launchDate);
    }
    
}

extension Array where Element == ApplicationObject {
    
    func sorted(by column: SortObject) -> [Element] {
        if column.ascending {
            switch column.name {
            case .name:
                return self.sorted(by: {$0.name < $1.name})
            case .indentifier:
                return self.sorted(by: {$0.identifier < $1.identifier})
            case .date:
                return self.sorted(by: {$0.date < $1.date})
            case .pid:
                return self.sorted(by: {$0.pid < $1.pid})
            }
        } else {
            switch column.name {
            case .name:
                return self.sorted(by: {$0.name > $1.name})
            case .indentifier:
                return self.sorted(by: {$0.identifier > $1.identifier})
            case .date:
                return self.sorted(by: {$0.date > $1.date})
            case .pid:
                return self.sorted(by: {$0.pid > $1.pid})
            }
        }
    }
    
}
