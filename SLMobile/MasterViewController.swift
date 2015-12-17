//
//  MasterViewController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/6/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit
import SwiftyJSON

class MasterViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: Properties
    var detailViewController: DetailViewController? = nil
    
    var searchController: UISearchController!
    var requestController = SLRequestController()
    var resultsController: ResultsTableViewController!
    
    // MARK: Model
    var itemList = [SLItem]() {
        didSet {
            updateTableview()
        }
    }

    // MARK: Dummy Data
    func addDummyData() {
        let mainBundle = NSBundle.mainBundle()
        
        if let sl_test_data = NSArray(contentsOfURL: mainBundle.URLForResource("sl_test_data", withExtension: "plist")!) {
            Debug.log("Found sl_test_data")
            for item in sl_test_data {
                if let computer = item as? NSDictionary {
                    let computerToAdd = Computer(json: JSON(computer))
                    itemList.append(computerToAdd)
                    Debug.logVerbose("Added computer: \(computerToAdd)")
                }
            }
        }
        if itemList.count > 0 {
            updateTableview()
        } // end dummy data.
    }
    
    func updateTableview() {
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            // Dispatch to the main queue in order to update UI
//            self.tableView.reloadData()
//        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.tableView.reloadData()
        }
    }

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add dummy data:
//        addDummyData()
        
        tableView.estimatedRowHeight = 74.0
        
        // This allows us to handle iPad setup gracefully
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        resultsController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ResultsTableViewController") as! ResultsTableViewController
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
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
        // add other segues by identifier to differentiate what kind of detail to show
        if segue.identifier == "showGenericDetail" {
            if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                let object = itemList[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! GenericDetailTableViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            if let indexPath = resultsController.tableView.indexPathForCell(sender as! UITableViewCell) {
                let object = resultsController.filteredResults[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! GenericDetailTableViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "showDetailFromSearch" {
            Debug.log("Got to segue 'showDetailFromSearch'")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === self.tableView {
            return
        } else {
            Debug.log("Looking at the other tableview")
            performSegueWithIdentifier("showGenericDetail", sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        Debug.logVerbose("Text changed: \(searchController.searchBar.text!)")
        // TODO: Fill this in with request code
        let resultsController = searchController.searchResultsController as! ResultsTableViewController
        
        // Only start searching after 3 or more characters
        guard (searchController.searchBar.text?.characters.count > 2)
            else { return }
        
        let tableToSearch = SLKey.Table.ConfigurationItem
        
        if let searchTerm = searchController.searchBar.text {
            requestController.makeRequest(searchTerm, forSLTable: tableToSearch, completionHandler: { (array) -> Void in
                var newResults = [SLItem]()
                for item in array {
                    switch tableToSearch {
                    case .ConfigurationItem:
                        newResults.append(Computer(dictionary: item))
                    case .Asset:
                        newResults.append(Computer(dictionary: item))
                    case .Incident:
                        newResults.append(Incident(dictionary: item))
                    case .KnowledgeBase:
                        newResults.append(KnowledgeBaseArticle(dictionary: item))
                    }
                }
                resultsController.filteredResults = newResults
                resultsController.updateTableview()
            })
        }
    }
    
    // MARK: - UISearchBarDelegate
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        Debug.logVerbose("Text changed: \(searchText)")
//        
//        
//    }
    
    // MARK: - Custom Setup Methods
    
    private func configureMasterCell(cell: UITableViewCell, forComputer computer: Computer) {
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

