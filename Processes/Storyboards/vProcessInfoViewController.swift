//
//  vProcessInfoViewController.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa

class vProcessInfoViewController: NSViewController {
    
    @IBOutlet var processInfoObject: ProcessInfoObject!;
    
    override var representedObject: Any? {
        didSet {
            self.update();
        }
    }
    
    private func update() {
        guard let process = self.representedObject as? ProcessRecord else {
            return;
        }
        self.processInfoObject.process = process;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
