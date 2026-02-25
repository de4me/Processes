//
//  vTaskInfoViewController.swift
//  Processes
//
//  Created by DE4ME on 24.02.2026.
//

import Cocoa

class vTaskInfoViewController: NSViewController {
    
    @IBOutlet var taskInfoOject: TaskInfoObject!
    
    override var representedObject: Any? {
        didSet {
            self.taskInfoOject.application = self.representedObject as? ApplicationObject;
        }
    }
    
#if DEBUG
    deinit {
        print(#function, NSStringFromClass( type(of: self) ));
    }
#endif
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
}
