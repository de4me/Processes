//
//  NSViewController+Utils.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import Cocoa;


extension NSViewController {
    
    func splitViewController<T: NSViewController>(of type: T.Type) -> NSViewController? {
        guard let parent = self.parent as? NSSplitViewController,
              let item = parent.splitViewItems.first(where: {$0.viewController is T})
        else {
            return nil;
        }
        return item.viewController;
    }
    
    @objc private func showError(_ error: Error) {
        guard let window = self.view.window else {
            return;
        }
        window.presentError(error);
    }
    
    func showError(onMainThread error: Error) {
        if Thread.isMainThread {
            self.showError(error);
        } else {
            self.performSelector(onMainThread: #selector(self.showError(_:)), with: error, waitUntilDone: false);
        }
    }
}
