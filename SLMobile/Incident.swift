//
//  Incident.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/28/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Incident: SLItem {
    
    private let backEndStore: JSON
    
    init(json: JSON) {
        backEndStore = json
    }
    
    init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }
    
    func valueForKey(key: String) -> String? {
        return backEndStore[key].string
    }
    
}