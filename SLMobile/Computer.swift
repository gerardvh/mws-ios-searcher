//
//  Computer.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//


import Foundation
import SwiftyJSON


struct Computer: SLItem {
    
    private var backEndStore: NSDictionary
    
    init(dictionary: NSDictionary) {
        backEndStore = dictionary
    }
    
    init() {
        // Convenience init
        self.init(dictionary: NSDictionary())
    }
    
    init?(json: JSON) {
        if let jsonDict = json.dictionary {
            let dict = NSDictionary()
            
            for (key, subJson): (String, JSON) in jsonDict {
                dict.setValue(subJson.string, forKey: key)
            }
            
            self.init(dictionary: dict)
        } else {
            return nil
        }
    }
    
    func valueForKey(key: String) -> String? {
        let value = backEndStore.valueForKey(key) as? String
        guard value != ""
            else { return nil } // Don't want empty strings, want to replace with an if let when called.
        return value
    }
    
    var sectionsDict: Dictionary<String, [SLKey.Field]> = [
        "Identifiers": [.AssetTag, .SerialNumber],
        "People Involved": [.AssignedToFullname, .Location, .Department],
        "Comments": [.Comments],
        "Tech Specs": [.ModelID, .Manufacturer, .MacAddress, .Placeholder]
    ]
    
    var sectionsArray: [String] {
        return ["Identifiers", "People Involved", "Comments", "Tech Specs"]
    }
}