//
//  ObserverProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


protocol ObserverProtocol {
    var observationArray: [NSKeyValueObservation] { get set }
    mutating func registerObservers();
    mutating func unregisterObservers();
}
