//
//  DateTransformation.swift
//  Processes
//
//  Created by DE4ME on 25.02.2026.
//

import Cocoa;


@objc(DateTransformation)
class DateTransformation: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? Date else {
            return "";
        }
        return DateFormatter.localizedString(from: value, dateStyle: .short, timeStyle: .short);
    }
    
}
