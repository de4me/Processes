//
//  ObserverProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


protocol ObserverProtocol {
    func registerObservers() -> [NSKeyValueObservation];
}
