//
//  KnowledgeBaseArticle.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/28/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct KnowledgeBaseArticle: SLItem {
    
    private let backEndStore: JSON
    
    init(json: JSON) {
        backEndStore = json
    }
    
    func valueForKey(key: String) -> String? {
        return backEndStore[key].string
    }
    
}