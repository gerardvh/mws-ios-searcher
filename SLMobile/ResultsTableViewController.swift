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
        let nib = UINib(nibName: ComputerCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ComputerCell.ID)
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



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
