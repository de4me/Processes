//
//  SessionsDataSource.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;
import CoreData;


class SessionsDataSource: NSObject {
    
    @IBOutlet var sessionsObjects: SessionsObject!;

}


extension SessionsDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        self.sessionsObjects.count;
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.sessionsObjects.objectValue(for: .name, at: row);
    }
    
}
