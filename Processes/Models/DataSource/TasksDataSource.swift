//
//  TasksDataSource.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


class TasksDataSource: NSObject {
    
    @IBOutlet var tasksObject: TasksObject!;

}


extension TasksDataSource : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        self.tasksObject.applications.count;
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn,
              let column = SortColumnName(columnIdentifier: tableColumn.identifier)
        else {
            return nil;
        }
        return self.tasksObject.objectValue(for: column, at: row);
    }
    
}
