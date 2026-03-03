//
//  RunningApplicationProtocol.swift
//  Processes
//
//  Created by DE4ME on 03.03.2026.
//

import Cocoa;


@objc protocol RunningApplicationProtocol {
    
    func hide() -> Bool;
    func unhide() -> Bool;
    func activate(options: NSApplication.ActivationOptions) -> Bool;
    func browseBundle();
    func browseExecutable();
    
}
