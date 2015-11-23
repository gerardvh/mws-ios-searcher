//
//  SLItemProtocol.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/28/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation

protocol SLItem {
  
//    static func initWithDictionary(dict: NSDictionary) -> SLItem
    
    init(dictionary: NSDictionary)
    
    func valueForKey(key: String) -> String?
    
    subscript(_: String) -> String? { get }
    
    var sectionsDict: Dictionary<String,[String]> { get }
    
    var sectionsArray: [String] { get }
}

extension SLItem {
    // Default implementation to be overwritten
    // TODO: USE SLKEYS and then how to have Display values and searchable values?
    var sectionsDict: Dictionary<String, [String]> { return [
        "Identifiers": ["Asset Tag", "Serial Number"],
        "People Involved": ["Assigned To", "Location", "Department"],
        "Comments": ["Comments"],
        "Tech Specs": ["Model", "Manufacturer", "MAC Address", "Placeholder"]
        ] }
    var sectionsArray: [String] {
        return ["Identifiers", "People Involved", "Comments", "Tech Specs"]
    }
}