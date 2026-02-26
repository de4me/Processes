//
//  ProcessProtocol.swift
//  Processes
//
//  Created by DE4ME on 26.02.2026.
//

import Cocoa;


@objc protocol ProcessProtocol: BrowseProtocol {
    var pid: pid_t {get}
}
