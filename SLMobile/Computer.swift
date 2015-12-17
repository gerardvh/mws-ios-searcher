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
    //MARK: - Properties
    private let backEndStore: JSON
    
    var serialNumber: String?
    var assetTag: String?
    var assignedTo: String?
    var location: String?
    var department: String?
    var model: String?
    var manufacturer: String?
    var macAddress: String?
    
    var sectionsDict: Dictionary<String, [SLKey.Field]> = [
        "Identifiers": [.AssetTag, .SerialNumber],
        "People Involved": [.AssignedToFullname, .Location, .Department],
        "Comments": [.Comments],
        "Tech Specs": [.ModelID, .Manufacturer, .MacAddress, .Placeholder]
    ]
    
    var sectionsArray: [String] {
        return ["Identifiers", "People Involved", "Comments", "Tech Specs"]
    }
    
    //MARK: - Initializers
    init() {
        // Convenience init
        self.init(json: [:])
    }
    
    init(json: JSON) {
        backEndStore = json
        serialNumber = backEndStore[.SerialNumber].string
        assetTag     = backEndStore[.AssetTag].string
        assignedTo   = backEndStore[.AssignedToFullname].string
        location     = backEndStore[.Location].string
        department   = backEndStore[.Department].string
        model        = backEndStore[.ModelID].string
        manufacturer = backEndStore[.Manufacturer].string
        macAddress   = backEndStore[.MacAddress].string
    }
    
    init(dictionary: NSDictionary) {
        // Pass our NSDictionary to the JSON initializer
        self.init(json: JSON(dictionary))
    }
    
    func valueForKey(key: String) -> String? {
        let value = backEndStore[key].string
        if value == "" {
            return nil
        } else {
            return value
        }
    }
}