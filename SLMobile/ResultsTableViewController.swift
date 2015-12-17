//
//  ResultsTableViewController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 12/3/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var filteredResults = [SLItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: ComputerCell.nibName, bundle: nil)
//        tableView.registerNib(nib, forCellReuseIdentifier: ComputerCell.ID)
        
        tableView.estimatedRowHeight = 60.0
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ComputerCell.ID, forIndexPath: indexPath)

        if let computer = filteredResults[indexPath.row] as? Computer {
            ComputerCell.configureCell(cell, forComputer: computer)
        }
        return cell
    }
    
    func updateTableview() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            // Dispatch to the main queue in order to update UI
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        Debug.log("Selected row at \(indexPath.row)")
//        // Then go to the detail view
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetailFromSearch" {
//            Debug.log("Got to segue 'showDetailFromSearch'")
//            if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
//                let object = filteredResults[indexPath.row]
//                let navController = (segue.destinationViewController as! UINavigationController)
//                let controller = navController.topViewController as! GenericDetailTableViewController
//                controller.detailItem = object
//                navController.navigationBarHidden = false
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
   
    

}
