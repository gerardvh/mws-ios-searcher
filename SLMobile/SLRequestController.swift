//
//  SLRequestController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/23/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class SLRequestController: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
    
    private var session: NSURLSession?
    private var dataTask: NSURLSessionDataTask?
    
    private func getSession() -> NSURLSession {
        guard self.session == nil
            else { return self.session! }
        
        Debug.log("Creating a new Session")
        
        self.session = configureSession()
        return self.session!
    }
    
    private func defaultQueryItems(searchTerm: String) -> [NSURLQueryItem] {
        let queryDict = [
            SLKey.Field.SerialNumber: searchTerm,
            SLKey.Field.AssetTag: searchTerm,
            SLKey.Field.AssignedToFullname: searchTerm,
            SLKey.Field.AssignedToUsername: searchTerm
        ]
        
        let slQueryString = queryDict.asSLQueryString(separator: .Or, queryModifier: .FuzzyMatch)
        
        let query = [
            SLKey.SysParm.Query: slQueryString,
            SLKey.SysParm.Limit: "100",
            SLKey.SysParm.DisplayValue: "true",
            SLKey.SysParm.ExcludeReference: "true"
        ]
        return query.asQueryItems
    }
    
    // Basically I want to be able to either pass in a String as a query (which uses the default setup),
    // or I can pass in a Dictionary when I set up the different filter options to specify what I'm searching.
    
    func makeRequest(searchTerm: String, completionHandler handler: ([NSDictionary]) -> Void) {
        let request = self.configureRequest(searchTerm)
        let singleSession = getSession()
        
        // Stop the running data task if we enter this method while there is still a data task pending
        // this way we don't get the results for an old data task
        if ((self.dataTask) != nil) {
            Debug.log("Canceling existing dataTask")
            self.dataTask?.cancel()
        }
        // After making sure that we don't already have an active request, continue on with the dataTask
        self.dataTask = singleSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            // Verify that we have not already canceled this dataTask, otherwise return early.
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
            }
        }
        self.dataTask?.resume()
    }
    
    func makeSpecificRequest(searchDict: Dictionary<String, String>, completionHandler handler: ([NSDictionary]) -> Void) {
        fatalError("makeSpecificRequest not implemented yet.")
    }
    
    func invalidateSession() {
        self.session?.invalidateAndCancel()
        Debug.log("Invalidating session")
    }
    
    private func configureSession() -> NSURLSession {
        let config                   = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization": SLKey.API.authString, "Accept": "application/json"]
        return NSURLSession(configuration: config)
        
    }
    
    private func configureRequest(searchTerm: String) -> NSURLRequest {
        return configureRequest(searchTerm, queryItems: defaultQueryItems(searchTerm))
    }
    
    private func configureRequest(searchTerm: String, queryItems: [NSURLQueryItem]) -> NSURLRequest {
        let urlComponents = SLKey.Table.ConfigurationItem.urlComponents
        urlComponents.queryItems = queryItems
        return NSURLRequest(URL: urlComponents.URL!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
    }
    
}

// MARK: - Private Dictionary extension

private extension Dictionary {
    func asSLQueryString(separator separator: SLKey.QuerySeparator = .Or, queryModifier: SLKey.QueryModifier = .FuzzyMatch) -> String {
        var queryValues = [String]()
        
        for (key, value) in self {
            // Make sure we can coerce the types to String values
            guard let key = key as? String, value = value as? String
                else { continue }
            queryValues.append("\(key)\(queryModifier.rawValue)\(value)")
        }
        let queryString = queryValues.joinWithSeparator(separator.rawValue)
        
        return queryString
    }
    
    var asQueryItems: [NSURLQueryItem] {
        var queryItems = [NSURLQueryItem]()
        for (key, value) in self {
            // Make sure we can coerce the types to String values
            guard let key = key as? String, value = value as? String
                else { continue }
            queryItems.append(NSURLQueryItem(name: key, value: value))
        }
        return queryItems
    }
}