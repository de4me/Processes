//
//  SegueIdentifierName.swift
//  Processes
//
//  Created by DE4ME on 24.02.2026.
//

import Cocoa;


fileprivate enum SegueIdentifierName: String {
    case taskinfo;
    case processinfo;
}


extension NSViewController {
    
    struct SegueName {
        static let TaskInfo: String = SegueIdentifierName.taskinfo.rawValue;
        static let ProcessInfo: String = SegueIdentifierName.processinfo.rawValue;
    }
    
}
