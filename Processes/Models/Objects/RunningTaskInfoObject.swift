//
//  RunningTaskInfoObject.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


class RunningTaskInfoObject: TaskInfoObject {
    
    @objc dynamic private(set) var icon: NSImage?;
    @objc dynamic private(set) var activationPolicy: NSApplication.ActivationPolicy;
    
    override init() {
        self.activationPolicy = .regular;
        super.init();
    }
    
    override var application: ApplicationObject? {
        didSet {
            prepare();
        }
    }
    
    private func prepare() {
        guard let application = self.application,
              let runningapplication = NSRunningApplication(processIdentifier: application.pid)
        else {
            return;
        }
        self.icon = runningapplication.icon;
        self.activationPolicy = runningapplication.activationPolicy;
    }
    
}
