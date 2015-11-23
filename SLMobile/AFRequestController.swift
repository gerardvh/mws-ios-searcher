//
//  AFRequestController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation

struct AFRequestController {
    
    func searchFor(searchTerm: String, completionHandler handler: ([SLItem]) -> Void) {
        
    }
    
    func completeSearch(searchTerm: String, table: SLKey.Table, fieldsToSearch fields: [SLKey.Field], maxResults: Int, queryModifier modifier: SLKey.QueryModifier, querySeparator separator: SLKey.QuerySeparator, completionHandler handler: ([SLItem]) -> Void) {
//        let url = table.url
        
    }
    
    private func makeSLQueryString(fromDictionary dict: Dictionary<SLKey.Field, String>, withSeparator sep: SLKey.QuerySeparator = .Or, withQueryModifier mod: SLKey.QueryModifier = .FuzzyMatch) -> String {
        var queryValues = [String]()
        
        for (key, value) in dict {
            queryValues.append("\(key.rawValue)\(mod.rawValue)\(value)")
        }
        return queryValues.joinWithSeparator(sep.rawValue)
    }
}
