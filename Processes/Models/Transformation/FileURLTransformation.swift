//
//  FileURLTransformation.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


@objc(FileURLTransformation)
class FileURLTransformation: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? URL else {
            return "";
        }
        return value.relativePath;
    }
    
}
