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
            SLKey.Fields.SerialNumber: searchTerm,
            SLKey.Fields.AssetTag: searchTerm,
            SLKey.Fields.AssignedTo.Fullname: searchTerm,
            SLKey.Fields.AssignedTo.Username: searchTerm
        ]
        
        let slQueryString = queryDict.asSLQueryString(separator: "^OR")
        
        let query = [
            SLKey.SysParms.Query: slQueryString,
            SLKey.SysParms.Limit: "100",
            SLKey.SysParms.DisplayValue: "true",
            SLKey.SysParms.ExcludeReference: "true"
        ]
        return query.asQueryItems
    }
    
    // Basically I want to be able to either pass in a String as a query (which uses the default setup),
    // or I can pass in a Dictionary when I set up the different filter options to specify what I'm searching.
    
    func makeRequest(searchTerm: String, completionHandler handler: ([Computer]) -> Void) {
        
        let request = self.configureRequest(searchTerm)
        let singleSession = getSession()
        
        if ((self.dataTask) != nil) {
            Debug.log("Canceling existing dataTask")
            self.dataTask?.cancel()
        }
        
        self.dataTask = singleSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            // Verify that we have not already canceled this dataTask, otherwise return early.
            guard data != nil
                else { Debug.log("Data was nil"); return }
            Debug.log("Got data")
            var computers = [Computer]()
            do {
                // Already know that data will not be nil
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let
                    jsonResponse = jsonData as? Dictionary<String, AnyObject>,
                    result       = jsonResponse["result"] as? [NSDictionary] {
                        for element in result {
                            computers.append(Computer(dictionary: element))
                        }
                        // Send the new array back to our handler.
                        handler(computers)
                } else {
                    Debug.log("Maybe ServiceLink error")
                }
            } catch {
                Debug.log("Error converting json data: \(error)")
            }
        }
        self.dataTask?.resume()
    }
    
    func makeSpecificRequest(searchDict: Dictionary<String, String>) {
        fatalError("makeSpecificRequest not implemented yet.")
    }
    
    func invalidateSession() {
        self.session?.invalidateAndCancel()
        Debug.log("Invalidating session")
    }
    
    private func configureSession() -> NSURLSession {
        let config                   = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization": SLKey.API.authString, "Accept": "application/json"]
        
        let session = NSURLSession(configuration: config)
        return session
        
    }
    
    private func configureRequest(searchTerm: String) -> NSURLRequest {
        let urlComponents = SLKey.ConfigurationItem.urlComponents
        urlComponents.queryItems = defaultQueryItems(searchTerm)
        return NSURLRequest(URL: urlComponents.URL!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
    }
    
    
}

private extension Dictionary {
    func asSLQueryString(separator separator: String = SLKey.QuerySeparators.Or) -> String {
        var queryValues = [String]()
        
        for (key, value) in self {
            // Make sure we can coerce the types to String values
            guard let key = key as? String, value = value as? String
                else { continue }
            queryValues.append("\(key)\(SLKey.QueryModifiers.FuzzyMatch)\(value)")
        }
        let queryString = queryValues.joinWithSeparator(separator)
        
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