//
//  SLRequestController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class SLRequestController: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
//    MARK: - Properties
    /// Optional dataTask. This is cancelled whenever we start a new dataTask.
    private var dataTask: NSURLSessionDataTask?
    
//    MARK: - Singleton NSURLSession
    /// Singleton NSURLSession
    static let singleSession: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization": SLAPI.authString, "Accept": "application/json"]
        return NSURLSession(configuration: config)
    }()
    
//    MARK: - Published API
    /**
     Main public API for making ServiceLink requests
     
     - parameter searchTerm:       Text to use for searching accross the provided fields in ServiceLink.
     - parameter table:            Which ServiceLink table to search, defaults to SLKey.Table.ConfigurationItem
     - parameter fields:           Fields to search using the provided `searchTerm`. Defaults to an `OR` search with fuzzy matching (`LIKE`). Default fields are .SerialNumber, .AssetTag, .AssignedToFullname, .AssignedToUsername.
     - parameter limit:            Max number of results to return from ServiceLink. It may improve performance to reduce this number. Defaults to 100.
     - parameter displayOnly:      Whether or not to show ServiceLink `sys_id`s, or just the human readable format. Defaults to `true`, which is human readable.
     - parameter excludeReference: Whether or not to return ServiceLink API addresses for references, such as Location or User. Defaults to `true`, which omits these links.
     - parameter handler:          Completion handler to do something with the array of NSDictionaries returned from JSON serialization. The returned array will be nil if there is an error.
     */
    func makeRequest(
        searchTerm: String,
        forSLTable table: SLKey.Table = .ConfigurationItem,
        fieldsToQuery fields: [SLKey.Field] = [.SerialNumber, .AssetTag, .AssignedToFullname, .AssignedToUsername],
        resultLimit limit: Int = 100,
        displayOnly: Bool = true,
        excludeReference: Bool = true,
        completionHandler handler: ([NSDictionary]?) -> Void)
            -> Void
    {
        // Stop the running data task if we enter this method while there is still a data task pending
        // this way we don't get the results for an old data task
        if ((self.dataTask) != nil) {
            Debug.log("Canceling existing dataTask")
            self.dataTask?.cancel()
        }
        
        // Setup request with defaults or with passed in args
        let request = self.configureDefaultRequest(searchTerm, table: table, fields: fields, limit: limit, displayOnly: displayOnly, excludeReference: excludeReference)
        let session = SLRequestController.singleSession
        // After making sure that we don't already have an active request, continue on with the dataTask
        self.dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let dataUnwrapped = data
                else {
                    Debug.log("Data was nil")
                    return
                }
            // Guaranteed that we have data at this point
            Debug.log("Got data")
            // Use guard to return early and show our `else` cases near the code that triggers them
            guard let
                jsonData = try? NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .AllowFragments),
                jsonResponse = jsonData as? Dictionary<String, AnyObject>
                else {
                    Debug.log("Unable to parse JSON from data: \(dataUnwrapped)")
                    handler(nil)
                    return
                }
            // Results from ServiceLink are arrays of dictionaries, here we know we have a result from SL
            if let result = jsonResponse["result"] as? [NSDictionary] {
                // Send the Array back to our handler
                handler(result)
            } else if let jsonError = jsonResponse["error"] as? NSDictionary {
                // When a query doesn't match anything, ServiceLink sends back an `error` dictionary
                Debug.log("SL Error: \(jsonError["message"])")
                handler(nil)
            } else {
                Debug.log("Unknown error in Service Link response")
            }
        }
        self.dataTask?.resume()
    }
    
//    MARK: - Helper Functions
    /**
     Internal function for setting up the NSURLRequest.
     */
    private func configureDefaultRequest(
        searchTerm: String,
        table: SLKey.Table,
        fields: [SLKey.Field],
        limit: Int,
        displayOnly: Bool,
        excludeReference: Bool)
            -> NSURLRequest
    {
        let queryString = getQueryString(searchTerm, fieldsToQuery: fields)
        let queryItems = getQueryItems(queryString, limit: limit, displayOnly: displayOnly, excludeReference: excludeReference)
        return configureRequest(searchTerm, queryItems: queryItems, table: table)
    }
    
    /**
     Internal function for setting up the NSURLRequest.
     */
    private func configureRequest(
        searchTerm: String,
        queryItems: [NSURLQueryItem],
        table: SLKey.Table)
            -> NSURLRequest
    {
        let urlComponents = table.urlComponents
        urlComponents.queryItems = queryItems
        return NSURLRequest(URL: urlComponents.URL!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
    }
    
    /**
     Internal function for creating query strings appropriate for use with the ServiceLink API.
     
     - parameter searchTerm: Text to search for accross provided `fields`.
     - parameter fields:     Fields in which to search for the `searchTerm`.
     - parameter sep:        Switch whether this is an `OR` or `AND` search across the `fields`.
     - parameter mod:        Switch whether this is a `LIKE` search or a `=` search for each field.
     
     - returns: String appropriate for use in the ServiceLink API as the value for key `sysparm_query`.
     */
    private func getQueryString(
        searchTerm: String,
        fieldsToQuery fields: [SLKey.Field],
        querySeparator sep: SLKey.QuerySeparator = .Or,
        queryModifier mod: SLKey.QueryModifier = .FuzzyMatch)
            -> String
    {
        var queryDict = Dictionary<SLKey.Field, String>()
        
        for field in fields {
            queryDict[field] = searchTerm
        }
        
        var queryValues = [String]()
        
        for (key, value) in queryDict {
            queryValues.append("\(key.rawValue)\(mod.rawValue)\(value)")
        }
        
        return queryValues.joinWithSeparator(sep.rawValue)
    }
    
    /**
     Internal function for creating an array of `NSURLQueryItem`s which is then used by `configureRequest(...)` as the `queryItems` property of the `NSURLComponents` class to create the full query string for submitting to the ServiceLink API.
     
     - parameter query:            ServiceLink formatted query string, like the one provided by `getQueryString(...)`.
     - parameter limit:            Max number of results to return from ServiceLink.
     - parameter displayOnly:      Whether or not to show ServiceLink `sys_id`s, or just the human readable format. Defaults to `true`, which is human readable.
     - parameter excludeReference: Whether or not to return ServiceLink API addresses for references, such as Location or User. Defaults to `true`, which omits these links.
     
     - returns: Array of `NSURLQueryItem`s appropriate for use with `configureRequest(...)`.
     */
    private func getQueryItems(
        query: String,
        limit: Int,
        displayOnly: Bool,
        excludeReference: Bool)
            -> [NSURLQueryItem]
    {
        let query = [
            SLKey.SysParm.Query: query,
            SLKey.SysParm.Limit: String(limit),
            SLKey.SysParm.DisplayValue: String(displayOnly),
            SLKey.SysParm.ExcludeReference: String(excludeReference)
        ]
        
        var queryItems = [NSURLQueryItem]()
        for (key, value) in query {
            queryItems.append(NSURLQueryItem(name: key.rawValue, value: value))
        }
        
        return queryItems
    }
    
}
