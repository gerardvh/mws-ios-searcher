//
//  MasterViewController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/6/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    // MARK: View Tags
    private struct ComputerCell {
        enum ViewTag: Int {
            case AssetTag       = 1
            case PersonAssigned = 2
            case SerialNumber   = 3
        }
        
        static let ID = "computerMasterCellID"
    }
    
    // MARK: Model
    var itemList = [Any]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    func addDummyData() {
        let mainBundle = NSBundle.mainBundle()
        
        if let sl_test_data = NSArray(contentsOfURL: mainBundle.URLForResource("sl_test_data", withExtension: "plist")!) {
            Debug.log("Found sl_test_data")
            for item in sl_test_data {
                if let computer = item as? NSDictionary {
                    itemList.append(Computer(dictionary: computer))
                    Debug.logVerbose("Added computer: \(computer)")
                }
            }
        }
        if itemList.count > 0 {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                // Dispatch to the main queue in order to update UI
                self.tableView.reloadData()
            }
        } // end dummy data.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add dummy data:
        addDummyData()
        
        tableView.estimatedRowHeight = 74.0
        
        // This allows us to handle iPad setup gracefully
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = itemList[indexPath.row] as! Computer
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ComputerDetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ComputerCell.ID, forIndexPath: indexPath)
        
        // Use a switch statement with 'case let' to pattern match and get the type of item

        let object = itemList[indexPath.row] as! Computer
        configureMasterCell(cell, forComputer: object)
        return cell
    }
    
    // MARK: - Custom Setup Methods
    
    private func configureMasterCell(cell: UITableViewCell, forComputer computer: Computer) {
        if let
            assetTagLabel       = cell.viewWithTag(ComputerCell.ViewTag.AssetTag.rawValue) as? UILabel,
            personAssignedLabel = cell.viewWithTag(ComputerCell.ViewTag.PersonAssigned.rawValue) as? UILabel,
            serialNumberLabel   = cell.viewWithTag(ComputerCell.ViewTag.SerialNumber.rawValue) as? UILabel
        {
            assetTagLabel.text       = computer.valueForKey(SLKey.Fields.AssetTag) ?? "No Asset Tag"
            personAssignedLabel.text = computer.valueForKey(SLKey.Fields.AssignedTo.Fullname) ?? "No Assignee"
            serialNumberLabel.text   = computer.valueForKey(SLKey.Fields.SerialNumber) ?? "No Serial Number"
        }
    }


}

