//
//  ProcessesDataSource.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;
import CoreData;


class ProcessesDataSource: NSObject {
    
    @IBOutlet var processesObject: ProcessesObject!;
    
}


extension ProcessesDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        self.processesObject.count;
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn,
              let column = SortColumnName(columnIdentifier: tableColumn.identifier)
              
        else {
            return nil;
        }
        return processesObject.objectValue(for: column, at: row);
    }
    
}
