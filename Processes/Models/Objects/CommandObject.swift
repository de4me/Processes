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
}
