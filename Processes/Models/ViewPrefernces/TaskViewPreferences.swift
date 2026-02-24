//
//  Task.swift
//  Processes
//
//  Created by DE4ME on 21.02.2026.
//

import Cocoa;


final class TaskViewPreferences: NSObject, Codable {
    
    enum CodingKeys: CodingKey, CaseIterable {
        case refreshInterval;
        case sort;
    }
    
    @objc dynamic var refreshInterval: TimeInterval = 1;
    @objc dynamic var sort: SortObject = .init(column: .name);
    
    override func setNilValueForKey(_ key: String) {
        switch key {
        case #keyPath(TaskViewPreferences.refreshInterval):
            self.refreshInterval = 0;
        default:
            break;
        }
    }
    
    override init() {
        super.init();
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.tryDecodeIfPresent(&self.refreshInterval, of: TimeInterval.self, forKey: .refreshInterval);
        container.tryDecodeIfPresent(&self.sort, of: SortObject.self, forKey: .sort);
    }
    
}


extension TaskViewPreferences: CodingKeysProtocol {
    
    func codingKeys() -> [any CodingKey] {
        CodingKeys.allCases;
    }
    
}


extension TaskViewPreferences: CodingNameProtocol {
    
}


extension TaskViewPreferences: ObjectAssigningProtocol {
    
}


extension TaskViewPreferences: LoadAndSaveProtocol {
    
}


extension TaskViewPreferences: SortColumnProtocol {
    
}
