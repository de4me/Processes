//
//  TaskInfoObject.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa

class TaskInfoObject: NSObject {
    
    @objc dynamic var application: ApplicationObject? {
        didSet {
            prepare();
        }
    }
    
    @objc dynamic private(set) var pid: pid_t;
    @objc dynamic private(set) var name: String;
    @objc dynamic private(set) var identifier: String;
    @objc dynamic private(set) var architecture: Int;
    @objc dynamic private(set) var launchDate: Date;
    @objc dynamic private(set) var bundleURL: URL;
    @objc dynamic private(set) var executableURL: URL;
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override init() {
        self.pid = 0;
        self.name = "";
        self.identifier = "";
        self.architecture = -1;
        self.launchDate = Date.distantPast;
        self.bundleURL = URL.rootURL;
        self.executableURL = URL.rootURL;
        super.init();
    }
    
    private func prepare() {
        guard let application = self.application else {
            return;
        }
        self.name = application.name;
        self.pid = application.pid;
        self.identifier = application.identifier;
        self.architecture = application.architecture;
        self.launchDate = application.date;
        self.bundleURL = application.bundleURL;
        self.executableURL = application.executableURL;
    }

}



