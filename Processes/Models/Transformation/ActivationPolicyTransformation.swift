//
//  ActivationPolicyTransformation.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


@objc(ActivationPolicyTransformation)
class ActivationPolicyTransformation: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? Int,
              let policy = NSApplication.ActivationPolicy(rawValue: value)
        else {
            return "";
        }
        switch policy {
        case .regular:
            return "Regular"
        case .accessory:
            return "Accessory"
        case .prohibited:
            return "Prohibited"
        @unknown default:
            return "(\(policy.rawValue)";
        }
    }
    
}
