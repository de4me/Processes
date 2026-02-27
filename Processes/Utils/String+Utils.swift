//
//  String+Utils.swift
//  Processes
//
//  Created by DE4ME on 26.02.2026.
//

import Cocoa;


extension String {
    
    init(osVersion: OperatingSystemVersion) {
        if osVersion.patchVersion == 0 {
            self = String(format: "%i.%i", osVersion.majorVersion, osVersion.minorVersion);
        } else {
            self = String(format: "%i.%i.%i", osVersion.majorVersion, osVersion.minorVersion, osVersion.patchVersion);
        }
    }
    
}
