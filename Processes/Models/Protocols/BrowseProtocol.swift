//
//  BrowseProtocol.swift
//  Processes
//
//  Created by DE4ME on 26.02.2026.
//

import Foundation


@objc protocol BrowseProtocol {
    
    var bundleURL: URL {get}
    var executableURL: URL {get}
    
}
