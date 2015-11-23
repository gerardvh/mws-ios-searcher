//
//  Computer.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//


import Foundation


struct Computer: SLItem {
    
    private var backEndStore: NSDictionary
    
    init(dictionary: NSDictionary) {
        backEndStore = dictionary
    }
    
    init() {
        // Convenience init
        self.init(dictionary: NSDictionary())
    }
    
    func valueForKey(key: String) -> String? {
        let value = backEndStore.valueForKey(key) as? String
        guard value != ""
            else { return nil } // Don't want empty strings, want to replace with an if let when called.
        return value
    }
    
    subscript(key: String) -> String? {
        return self.valueForKey(key)
    }
    
    var sectionsDict: Dictionary<String, [String]> = [
        "Identifiers": ["Asset Tag", "Serial Number"],
        "People Involved": ["Assigned To", "Location", "Department"],
        "Comments": ["Comments"],
        "Tech Specs": ["Model", "Manufacturer", "MAC Address", "Placeholder"]
    ]
    
    var sectionsArray: [String] {
        return ["Identifiers", "People Involved", "Comments", "Tech Specs"]
    }
}