//
//  AFRequestController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation
import Alamofire

struct AFRequestController {
    
    // MARK: - Defaults
    // TODO: Make these configurable and saved in NSUserDefaults
    private let defaultTable: SLKey.Table = .ConfigurationItem
    private let defaultFields: [SLKey.Field] = [.AssetTag, .SerialNumber, .AssignedToFullname, .AssignedToUsername]
    private let defaultMaxResults: Int = 25
    private let defaultQueryModifier: SLKey.QueryModifier = .FuzzyMatch
    private let defaultQuerySeparator: SLKey.QuerySeparator = .Or
    private let authHeader = ["Authorization": SLKey.API.authString]
    
    
    func searchFor(searchTerm: String, completionHandler handler: ([SLItem]) -> Void) {
        // Pass the search to `completeSearch(...)` with defaults
        completeSearch(searchTerm, table: defaultTable, fieldsToSearch: defaultFields, maxResults: defaultMaxResults, queryModifier: defaultQueryModifier, querySeparator: defaultQuerySeparator, completionHandler: handler)
    }
    
    private func completeSearch(searchTerm: String, table: SLKey.Table, fieldsToSearch fields: [SLKey.Field], maxResults: Int, queryModifier modifier: SLKey.QueryModifier, querySeparator separator: SLKey.QuerySeparator, completionHandler handler: ([SLItem]) -> Void) {
        // Handle our generic search
        var params = [String:AnyObject]()
        Alamofire.request(.GET, table.url, parameters: params, headers: authHeader)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    print("Success!")
                case .Failure(let error):
                    Debug.log("Failed in Alamofire request: \(response.request), with error: \(error)")
                }
        }
    }
    
    private func makeSLQueryString(fromDictionary dict: Dictionary<SLKey.Field, String>, withSeparator sep: SLKey.QuerySeparator = .Or, withQueryModifier mod: SLKey.QueryModifier = .FuzzyMatch) -> String {
        var queryValues = [String]()
        
        for (key, value) in dict {
            queryValues.append("\(key.rawValue)\(mod.rawValue)\(value)")
        }
        return queryValues.joinWithSeparator(sep.rawValue)
    }
}
