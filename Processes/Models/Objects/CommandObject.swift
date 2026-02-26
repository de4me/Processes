//
//  CommandObject.swift
//  Processes
//
//  Created by DE4ME on 26.02.2026.
//

import Cocoa;


class CommandObject: NSObject {
    
    private func browse(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url]);
    }

    @objc func browse(bundle: any BrowseProtocol) {
        self.browse(url: bundle.bundleURL);
    }
    
    @objc func browse(executable: any BrowseProtocol) {
        self.browse(url: executable.executableURL);
    }
    
    @objc func activate(process: any ProcessProtocol) {
        guard let process = NSRunningApplication(processIdentifier: process.pid) else {
            return;
        }
        process.activate(options: [.activateAllWindows]);
    }
    
    @objc func hide(process: any ProcessProtocol) {
        guard let process = NSRunningApplication(processIdentifier: process.pid) else {
            return;
        }
        process.hide();
    }
    
    @objc func show(process: any ProcessProtocol) {
        guard let process = NSRunningApplication(processIdentifier: process.pid) else {
            return;
        }
        process.unhide();
    }
    
}
