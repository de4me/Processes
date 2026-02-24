//
//  ProcessesViewPreferences.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;



final class ProcessesViewPreferences: NSObject, Codable {
    
    enum CodingKeys: CodingKey, CaseIterable {
        case sort;
    }
    
    @objc dynamic var sort: SortObject = .init(column: .name);
    
    override func setNilValueForKey(_ key: String) {
        
    }
    
    override init() {
        super.init();
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self);
        container.tryDecodeIfPresent(&self.sort, of: SortObject.self, forKey: .sort);
    }
    
}


extension ProcessesViewPreferences: CodingKeysProtocol {
    
    func codingKeys() -> [any CodingKey] {
        CodingKeys.allCases;
    }
    
}


extension ProcessesViewPreferences: CodingNameProtocol {
    
}


extension ProcessesViewPreferences: ObjectAssigningProtocol {
    
}


extension ProcessesViewPreferences: LoadAndSaveProtocol {
    
}


extension ProcessesViewPreferences: SortColumnProtocol {
    
}
