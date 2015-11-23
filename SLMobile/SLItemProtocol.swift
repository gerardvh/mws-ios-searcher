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
    
    func valueForKey(key: String) -> String? // Must be implemented by conforming types
    
    func valueForKey(key: SLKey.Field) -> String?
    
    subscript(key: String) -> String? { get }
    
    subscript(key: SLKey.Field) -> String? { get }
    
    var sectionsDict: Dictionary<String,[SLKey.Field]> { get }
    
    var sectionsArray: [String] { get }
}

extension SLItem {
    // Default implementation to be overwritten
    var sectionsDict: Dictionary<String, [SLKey.Field]> { return [
        "Identifiers": [.AssetTag, .SerialNumber],
        "People Involved": [.AssignedToFullname, .Location, .Department],
        "Comments": [.Comments],
        "Tech Specs": [.ModelID, .Manufacturer, .MacAddress, .Placeholder]
        ] }
    
    var sectionsArray: [String] {
        return ["Identifiers", "People Involved", "Comments", "Tech Specs"]
    }
    
    func valueForKey(key: SLKey.Field) -> String? {
        return self.valueForKey(key.rawValue)
    }
    
    subscript(key: String) -> String? {
        return self.valueForKey(key)
    }
    
    subscript(key: SLKey.Field) -> String? {
        return self.valueForKey(key.rawValue)
    }
}