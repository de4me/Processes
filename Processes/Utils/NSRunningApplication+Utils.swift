//
//  NSRunningApplication+Utils.swift
//  Processes
//
//  Created by DE4ME on 27.02.2026.
//

import Cocoa;





extension NSRunningApplication: RunningApplicationProtocol {

    @objc func browseBundle() {
        guard let url = self.bundleURL else {
            return;
        }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    @objc func browseExecutable() {
        guard let url = self.executableURL else {
            return;
        }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
}
