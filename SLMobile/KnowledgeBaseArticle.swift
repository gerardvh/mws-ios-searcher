////
////  KnowledgeBaseArticle.swift
////  ServiceLink Mobile
////
////  Created by Van Halsema, Gerard on 10/28/15.
////  Copyright © 2015 gerardvh. All rights reserved.
////
//
//import Foundation
//
//
//struct KnowledgeBaseArticle: SLItem {
//    
//    private let backEndStore: NSDictionary
//    
//    init(dictionary: NSDictionary) {
//        backEndStore = dictionary
//    }
//    
//    func valueForKey(key: String) -> String? {
//        return backEndStore.valueForKey(key) as? String
//    }
//    
//    subscript(key: String) -> String? {
//        return self.valueForKey(key)
//    }
//    
//}