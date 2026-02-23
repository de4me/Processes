//
//  TasksDataSource.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class TasksDataSource: NSObject {
    
    @IBOutlet var tasks: TasksObject!;

}


extension TasksDataSource : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        self.tasks.applications.count;
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn,
              let column = SortColumnName(columnIdentifier: tableColumn.identifier)
        else {
            return nil;
        }
        return self.tasks.objectValue(for: column, at: row);
    }
    
}
