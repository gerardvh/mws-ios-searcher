//
//  AFRequestController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct AFRequestController {
    
    // MARK: - Defaults
    // TODO: Make these configurable and saved in NSUserDefaults
    private let defaultTable: SLKey.Table = .ConfigurationItem
    private let defaultFields: [SLKey.Field] = [.AssetTag, .SerialNumber, .AssignedToFullname, .AssignedToUsername]
    private let defaultMaxResults: Int = 25
    private let defaultQueryModifier: SLKey.QueryModifier = .FuzzyMatch
    private let defaultQuerySeparator: SLKey.QuerySeparator = .Or
    private let authHeader = ["Authorization": SLKey.API.authString, "Accept": "application/json"]
    
    
    func searchFor(searchTerm: String, completionHandler handler: ([SLItem]) -> Void) {
        // Pass the search to `completeSearch(...)` with defaults
        completeSearch(searchTerm, table: defaultTable, fieldsToSearch: defaultFields, maxResults: defaultMaxResults, queryModifier: defaultQueryModifier, querySeparator: defaultQuerySeparator, completionHandler: handler)
    }
    
    private func completeSearch(searchTerm: String, table: SLKey.Table, fieldsToSearch fields: [SLKey.Field], maxResults: Int, queryModifier modifier: SLKey.QueryModifier, querySeparator separator: SLKey.QuerySeparator, completionHandler handler: ([SLItem]) -> Void) {
        
        let queryString = makeSLQueryString(forFields: fields, withSearchTerm: searchTerm)
        
        let params: [String:AnyObject] = [
            SLKey.SysParm.Query.rawValue: queryString,
            SLKey.SysParm.Limit.rawValue: maxResults,
            SLKey.SysParm.DisplayValue.rawValue: "true",
            SLKey.SysParm.ExcludeReference.rawValue: "true"
        ]
        
        Alamofire.request(.GET, table.url, parameters: params, headers: authHeader)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
//                    Debug.log("Successful Alamofire request: \(response.request), with value: \(value)")
                    // Do something with the response here
                    let json = JSON(value)
                    for item in json["result"] {
                        Debug.log("\(item.1)")
                    }
                case .Failure(let error):
                    Debug.log("Failed in Alamofire request: \(response.request), with error: \(error)")
                }
        }
    }
    
    private func makeSLQueryString(forFields fields: [SLKey.Field], withSearchTerm searchTerm: String, withSeparator sep: SLKey.QuerySeparator = .Or, withQueryModifier mod: SLKey.QueryModifier = .FuzzyMatch) -> String {
        var queryValues = [String]()
        // Create our initial query dictionary, searching for `searchTerm LIKE eachField`
        var queryDict: Dictionary<SLKey.Field, String> = [:]
        for field in fields {
            queryDict[field] = searchTerm
        }
        // Save it into queryValues with the format appropriate for SL queries
        for (key, value) in queryDict {
            queryValues.append("\(key.rawValue)\(mod.rawValue)\(value)")
        }
        return queryValues.joinWithSeparator(sep.rawValue)
    }
}
