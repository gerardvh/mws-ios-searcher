//
//  SLKey.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/21/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation

struct SLKey {
    enum Table: String {
        case Asset             = "alm_asset"
        case ConfigurationItem = "cmdb_ci"
        case Incident          = "incident"
        case KnowledgeBase     = "kb"// FIXME: Not correct
        
        var url: NSURL {
            let baseURL = NSURL(string: "https://umichqa.service-now.com/api/now/table/")
            return NSURL(string: self.rawValue, relativeToURL: baseURL)!
        }
        
        var urlComponents: NSURLComponents {
            return NSURLComponents(URL: self.url, resolvingAgainstBaseURL: true)!
        }
    }
    
    enum Field: String {
        case Location               = "location"
        case Monitor                = "monitor"
        case Asset                  = "asset"
        case UpdatedOnDate          = "sys_updated_on"
        case WarrantyExpirationDate = "warranty_expiration"
        case Category               = "category"
        case Manufacturer           = "manufacturer"
        case ModelID                = "model_id"
        case InstallStatus          = "install_status"
        case AssetTag               = "asset_tag"
        case Department             = "department"
        case CreatedOnDate          = "sys_created_on"
        case UpdatedBy              = "sys_updated_by"
        case Name                   = "name"
        case PurchaseDate           = "purchase_date"
        case SysID                  = "sys_id"
        case CreatedBy              = "sys_created_by"
        case SerialNumber           = "serial_number"
        case MacAddress             = "mac_address"
        case OperationalStatus      = "operational_status"
        case Comments               = "comments"
        case Placeholder            = "placeholder"
        
        case AssignedToUsername     = "assigned_to.user_name"
        case AssignedToFullname     = "assigned_to"
        
        var displayName: String {
            // Remove '_' and '.' and return a capitalized version
            let spacedString = self.rawValue.stringByReplacingOccurrencesOfString("_", withString: " ")
            let colonString = spacedString.stringByReplacingOccurrencesOfString(".", withString: ": ")
            return colonString.capitalizedString
        }
    }
    
    enum SysParm: String {
        case DisplayValue     = "sysparm_display_value"
        case Limit            = "sysparm_limit"
        case FieldsToReturn   = "sysparm_fields"
        case ExcludeReference = "sysparm_exclude_reference_link"
        case Query            = "sysparm_query"
    }
    
    enum QueryModifier: String {
        case ExactMatch = "="
        case FuzzyMatch = "LIKE"
    }
    
    enum QuerySeparator: String {
        case Or = "^OR"
        case And = "^"
    }
    
    struct API {
        private static let SLUser = "***REMOVED***"
        private static let SLPassword = "***REMOVED***"
        private static let credentialData = "\(SLUser):\(SLPassword)".dataUsingEncoding(NSUTF8StringEncoding)!
        private static let SLBase64Auth = credentialData.base64EncodedStringWithOptions([])
        static let authString = "Basic \(SLBase64Auth)"
    }
    
    
}