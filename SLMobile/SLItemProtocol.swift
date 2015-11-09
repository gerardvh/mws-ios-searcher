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
}