//
//  Debug.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/28/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation

struct Debug {
    
    static let switchOn = true
    static var verbose = false
    
    static func log(logString: String) {
        if (Debug.switchOn) { NSLog(logString) }
    }
    
    static func logVerbose(logString: String) {
        if (Debug.switchOn && Debug.verbose) { NSLog(logString) }
    }
}