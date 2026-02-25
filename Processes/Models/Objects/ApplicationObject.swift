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
    let architecture: Int;
    let bundleURL: URL;
    let executableURL: URL;
    
    init(name: String?, identifier: String?, pid: pid_t, date: Date?, architecture: Int, bundleURL: URL?, executableURL: URL?) {
        self.name = name ?? "";
        self.identifier = identifier ?? "";
        self.pid = pid
        self.date = date ?? Date();
        self.architecture = architecture;
        self.bundleURL = bundleURL ?? URL.rootURL;
        self.executableURL = executableURL ?? URL.rootURL;
    }
}


extension ApplicationObject {
    
    convenience init(runningApplication: NSRunningApplication) {
        self.init(name: runningApplication.localizedName, identifier: runningApplication.bundleIdentifier, pid: runningApplication.processIdentifier, date: runningApplication.launchDate, architecture: runningApplication.executableArchitecture, bundleURL: runningApplication.bundleURL, executableURL: runningApplication.executableURL);
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
