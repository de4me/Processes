//
//  ArchitectureTransformation.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


@objc(ArchitectureTransformation)
class ArchitectureTransformation: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? Int else {
            return "";
        }
        if #available(macOS 11.0, *) {
            switch value {
            case NSBundleExecutableArchitectureARM64:
                return "arm64"
            default:
                break;
            }
        }
        switch value {
        case NSBundleExecutableArchitecturePPC:
            return "Power PC"
        case NSBundleExecutableArchitectureI386:
            return "i386"
        case NSBundleExecutableArchitecturePPC64:
            return "Power PC 64"
        case NSBundleExecutableArchitectureX86_64:
            return "x86_64"
        default:
            return String(value);
        }
    }
    
}
