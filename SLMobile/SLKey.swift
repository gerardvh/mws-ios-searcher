//
//  SLKey.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/21/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import Foundation

enum SLKey {
    case Asset
    case ConfigurationItem
    case Incident
    
    
    struct Fields {
        static let Unverified             = "unverified"
        static let Location               = "location"
        static let PONumber               = "po_number"
        static let Domain                 = "sys_domain"
        static let ModCount               = "sys_mod_count"
        static let CostCC                 = "cost_cc"
        static let Monitor                = "monitor"
        static let Asset                  = "asset"
        static let UpdatedOnDate          = "sys_updated_on"
        static let WarrantyExpirationDate = "warranty_expiration"
        static let BusinessService        = "u_subscription_business_servic"
        static let Cost                   = "cost"
        static let Category               = "category"
        static let ChangeManagementIndic  = "u_sacm_change_management_indic"
        static let Manufacturer           = "manufacturer"
        static let ModelID                = "model_id"
        static let InstallStatus          = "install_status"
        static let AssetTag               = "asset_tag"
        static let CanPrint               = "can_print"
        static let Department             = "department"
        static let CreatedOnDate          = "sys_created_on"
        static let ExternallyHosted       = "u_externally_hosted"
        static let UpdatedBy              = "sys_updated_by"
        static let Name                   = "name"
        static let PurchaseDate           = "purchase_date"
        static let SkipSync               = "skip_sync"
        static let SysID                  = "sys_id"
        static let CreatedBy              = "sys_created_by"
        static let SerialNumber           = "serial_number"
        static let MacAddress             = "mac_address"
        static let Subcategory            = "subcategory"
        static let ClassName              = "sys_class_name"
        static let FaultCount             = "fault_count"
        static let OperationalStatus      = "operational_status"
        static let Comments               = "comments"
        
        struct AssignedTo {
            static let Username = "assigned_to.user_name"
            static let Fullname = "assigned_to"
        }
    }

    struct SysParms {
        static let DisplayValue           = "sysparm_display_value"
        static let Limit                  = "sysparm_limit"
        static let FieldsToReturn         = "sysparm_fields"
        static let ExcludeReference       = "sysparm_exclude_reference_link"
        static let Query                  = "sysparm_query"
    }
    
    
    struct QueryModifiers {
        static let ExactMatch = "="
        static let FuzzyMatch = "LIKE"
    }
    
    struct QuerySeparators {
        static let Or = "^OR"
        static let And = "^"
    }
    
    struct API {
        static let SLUser = "***REMOVED***"
        static let SLPassword = "***REMOVED***"
        static let SLBase64Auth = "c29hcC5uaXQ6eSFUIXBYczFQZVVA"
        static let authString = "Basic \(SLBase64Auth)"
    }
    
    private var tableName: String {
        switch self {
        case .Asset:
            return "alm_asset"
        case .ConfigurationItem:
            return "cmdb_ci"
        case .Incident:
            return "incident"
        }
    }
    
    var url: NSURL {
        let baseURL = NSURL(string: "https://umichqa.service-now.com/api/now/table/")
        return NSURL(string: self.tableName, relativeToURL: baseURL)!
    }
    
    var urlComponents: NSURLComponents {
        return NSURLComponents(URL: self.url, resolvingAgainstBaseURL: true)!
    }
}