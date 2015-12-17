//
//  GenericDetailTableViewController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/13/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class GenericDetailTableViewController: UITableViewController, DetailViewController {
    //TODO: Fix this whole class
    var detailItem: SLItem! // If we don't have an item, we can't do anything.
    
    let subtitleCellID = "basicSubtitleCellID"
    let commentsCellID = "commentsStackViewCellID"
    
    func configureView() {
        fatalError("Did not implement configureView()")
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 60
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return detailItem.sectionsArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < detailItem.sectionsArray.count
            else { return 0 }
        
        let currentSection = detailItem.sectionsArray[section]
        
        if let numberOfRows = detailItem.sectionsDict[currentSection]?.count {
            return numberOfRows
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellID: String
        
        if let commentsCellIndex = detailItem.sectionsArray.indexOf("Comments") where indexPath.section == commentsCellIndex {
            cellID = commentsCellID
        } else {
            cellID = subtitleCellID
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        guard cellID != commentsCellID else {
            let title = cell.viewWithTag(1) as! UILabel
            assignOptionalValueForLabel(title, value: detailItem[SLKey.Field.Comments])
            return cell
        }
        
        // Configure cells other than the comments cell
        if let
            section: String = detailItem.sectionsArray[indexPath.section],
            rowArray: [SLKey.Field] = detailItem.sectionsDict[section] {
                let title = cell.viewWithTag(1) as! UILabel
                let subtitle = cell.viewWithTag(2) as! UILabel
                let fieldKey: SLKey.Field = rowArray[indexPath.row]

                assignOptionalValueForLabel(title, value: detailItem[fieldKey])
                assignOptionalValueForLabel(subtitle, value: fieldKey.displayName)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailItem.sectionsArray[section]
    }

}
