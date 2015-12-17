//
//  SLRequestController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class SLRequestController: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
    
//    private var session: NSURLSession?
    private var dataTask: NSURLSessionDataTask?
    static let singleSession: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization": SLAPI.authString, "Accept": "application/json"]
        return NSURLSession(configuration: config)
    }()
    
    // Basically I want to be able to either pass in a String as a query (which uses the default setup),
    // or I can pass in a Dictionary when I set up the different filter options to specify what I'm searching.
    
    func makeRequest(
        searchTerm: String,
        completionHandler handler: ([NSDictionary]) -> Void)
            -> Void {
        let request = self.configureDefaultRequest(searchTerm)
        let session = SLRequestController.singleSession
        
        // Stop the running data task if we enter this method while there is still a data task pending
        // this way we don't get the results for an old data task
        if ((self.dataTask) != nil) {
            Debug.log("Canceling existing dataTask")
            self.dataTask?.cancel()
        }
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
                    return
                }
            // Results from ServiceLink are arrays of dictionaries, here we know we have a result from SL
            if let result = jsonResponse["result"] as? [NSDictionary] {
                // Send the Array back to our handler
                handler(result)
            }
            // When a query doesn't match anything, ServiceLink sends back an `error` dictionary
            if let error = jsonResponse["error"] as? NSDictionary {
                Debug.log("SL Error: \(error["message"])")
                handler([NSDictionary]())
            }
        }
        self.dataTask?.resume()
    }
    
    func makeSpecificRequest(searchDict: Dictionary<String, String>, completionHandler handler: ([NSDictionary]) -> Void) {
        fatalError("makeSpecificRequest not implemented yet.")
    }
    
    private func configureDefaultRequest(searchTerm: String)
            -> NSURLRequest {
        let queryItems = getQueryItems(getQueryString(searchTerm))
        return configureRequest(searchTerm, queryItems: queryItems)
    }
    
    private func configureRequest(
        searchTerm: String,
        queryItems: [NSURLQueryItem],
        table: SLKey.Table = .ConfigurationItem)
            -> NSURLRequest {
        let urlComponents = table.urlComponents
        urlComponents.queryItems = queryItems
        return NSURLRequest(URL: urlComponents.URL!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
    }
    
    private func getQueryString(
        searchTerm: String,
        fieldsToQuery fields: [SLKey.Field] = [.SerialNumber, .AssetTag, .AssignedToFullname, .AssignedToUsername],
        querySeparator sep: SLKey.QuerySeparator = .Or,
        queryModifier mod: SLKey.QueryModifier = .FuzzyMatch)
            -> String {
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
    
    private func getQueryItems(
        query: String,
        limit: Int = 100,
        displayOnly: Bool = true,
        excludeReference: Bool = true)
            -> [NSURLQueryItem] {
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
