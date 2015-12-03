//
//  ComputerCell.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 12/3/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

// MARK: View Tags
struct ComputerCell {
    struct ViewTag {
        static let AssetTag       = 1
        static let PersonAssigned = 2
        static let SerialNumber   = 3
    }
    
    //        static let ID = "computerMasterCellID"
    static let ID = "computerStackViewCellID"
    static let nibName = "ComputerCell"
    
    static func configureCell(cell: UITableViewCell, forComputer computer: Computer) {
        if let
            assetTagLabel       = cell.viewWithTag(ComputerCell.ViewTag.AssetTag) as? UILabel,
            personAssignedLabel = cell.viewWithTag(ComputerCell.ViewTag.PersonAssigned) as? UILabel,
            serialNumberLabel   = cell.viewWithTag(ComputerCell.ViewTag.SerialNumber) as? UILabel
        {
            assetTagLabel.text       = computer[SLKey.Field.AssetTag] ?? "No Asset Tag"
            personAssignedLabel.text = computer[SLKey.Field.AssignedToFullname] ?? "No Assignee"
            serialNumberLabel.text   = computer[SLKey.Field.SerialNumber] ?? "No Serial Number"
        }
    }

}