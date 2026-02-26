//
//  ProcessInfoObject.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


class ProcessInfoObject: NSObject {
    
    var process: ProcessRecord? {
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
        self.architecture = 0;
        self.launchDate = Date.distantPast;
        self.bundleURL = URL.rootURL;
        self.executableURL = URL.rootURL;
    }
    
    private func prepare() {
        guard let process = self.process else {
            return;
        }
        self.name = process.name;
        self.pid = process.pid;
        self.identifier = process.identifier;
        self.architecture = process.architecture;
        self.launchDate = process.date;
        self.bundleURL = process.bundleURL;
        self.executableURL = process.executableURL;
    }
    
}
