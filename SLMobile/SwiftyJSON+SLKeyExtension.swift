//
//  SwiftyJSON+SLKeyExtension.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 12/3/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    subscript(slkey: SLKey.Field) -> JSON {
        return self[slkey.rawValue]
    }
}