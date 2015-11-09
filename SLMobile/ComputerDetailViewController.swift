//
//  ComputerDetailViewController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/30/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class ComputerDetailViewController: UITableViewController {

    // MARK: - Constants for Storyboards
    static let storyboardName = "Main"
    static let viewControllerIdentifier = "ComputerDetailViewController"
    
    private let basicCellNibName = "ComputerDetailViewCell"
    private let basicCellID = "ComputerDetailCellID"
    
    var sizingCell: UITableViewCell?
    
    // MARK: - IB Outlets
    @IBOutlet weak var assetTagLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ownedByDepartmentLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var macAddressLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!

    // MARK: - Model
    
    var detailItem: Computer?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        setupTableViewCellNib(basicCellNibName, cellIdentifier: basicCellID)
//        
//        self.sizingCell = self.tableView.dequeueReusableCellWithIdentifier(self.basicCellID)
        guard let detailComputer = detailItem
            else {fatalError("Trouble getting detail computer")}
        
        // Using viewDidLoad() to assign values to our outlets from the computer provided during the segue
        assignOptionalValueForLabel(assetTagLabel, value: detailComputer[SLKey.Fields.AssetTag])
        assignOptionalValueForLabel(serialNumberLabel, value: detailComputer[SLKey.Fields.SerialNumber])
        assignOptionalValueForLabel(assignedToLabel, value: detailComputer[SLKey.Fields.AssignedTo.Fullname])
        assignOptionalValueForLabel(locationLabel, value: detailComputer[SLKey.Fields.Location])
        assignOptionalValueForLabel(ownedByDepartmentLabel, value: detailComputer[SLKey.Fields.Department])
        assignOptionalValueForLabel(commentsLabel, value: detailComputer[SLKey.Fields.Comments])
        assignOptionalValueForLabel(modelLabel, value: detailComputer[SLKey.Fields.ModelID])
        assignOptionalValueForLabel(macAddressLabel, value: detailComputer[SLKey.Fields.MacAddress])
        assignOptionalValueForLabel(manufacturerLabel, value: detailComputer[SLKey.Fields.Manufacturer])
        assignOptionalValueForLabel(placeholderLabel, value: detailComputer[SLKey.Fields.InstallStatus])
        
    }
    
    // MARK: - Custom setup methods
    
    /**
    Custom method to provide graceful fallback for optional labels.
    
    - parameter label: Label outlet from a storyboard.
    - parameter value: String? with text for the label. Will be replaced with "None" if .None
    */
    private func assignOptionalValueForLabel(label: UILabel, value: String?) {
        label.text = value ?? "None"
    }
    
//    class func getDetailViewController(forItem item: Computer) -> ComputerDetailViewController {
//        let sb = UIStoryboard(name: storyboardName, bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as! ComputerDetailViewController
//        
//        vc.detailComputer = item
//        
//        return vc
//    }
//    
//    func configureCell(cell: UITableViewCell, forComputer computer: Computer, atIndexPath indexPath: NSIndexPath) {
//        if let section = Sections(rawValue: indexPath.section) {
//            var key: String = ""
//            var label: String = ""
//            
//            switch section {
//            case .Identifiers:
//                if indexPath.row == 0 { // Asset Tag
//                    key = SLKey.Fields.AssetTag
//                    label = "Asset Tag"
//                } else { // Serial Number
//                    key = SLKey.Fields.SerialNumber
//                    label = "Serial Number"
//                }
//            case .People:
//                if indexPath.row == 0 { // Assigned To
//                    key = SLKey.Fields.AssignedTo.Fullname
//                    label = "Assigned To"
//                } else if indexPath.row == 1 { // Location
//                    key = SLKey.Fields.Location
//                    label = "Location"
//                } else if indexPath.row == 2 { // Department
//                    key = SLKey.Fields.Department
//                    label = "Owned By Department"
//                }
//            case .Comments:
//                // Only one section here
//                key = SLKey.Fields.Comments
//                // no label?
//            case .TechSpecs:
//                if indexPath.row == 0 { // Model
//                    key = SLKey.Fields.ModelID
//                    label = "Model"
//                } else if indexPath.row == 1 { // Mac Address
//                    key = SLKey.Fields.MacAddress
//                    label = "MAC Address"
//                } else if indexPath.row == 2 { // Manufacturer
//                    key = SLKey.Fields.Manufacturer
//                    label = "Manufacturer"
//                }
//            }
//            
//            setCellText(cell, forComputer: computer, withKey: key, labled: label)
//        }
//    }
//    
//    private func setCellText(cell: UITableViewCell, forComputer computer: Computer, withKey key: String, labled label: String) {
//        cell.textLabel?.text = computer.valueForKey(key) ?? "None"
//        cell.detailTextLabel?.text = label
//    }
//    
//    struct Static {
//        static var onceToken: dispatch_once_t = 0
//    }
//    
//    private func heightForBasicCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
//        // TODO: This doesn't work, need to more reliably set the sizingCell.
//        guard let cell = self.sizingCell
//            else { fatalError("Unable to configure sizing cell") }
//        
//        configureCell(cell, forComputer: detailComputer, atIndexPath: indexPath)
//        
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        
//        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        return size.height + 1.0
//    }
//    
//    private func calculateHeightForConfiguredSizingCell(cell: UITableViewCell) -> CGFloat {
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        
//        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        return size.height + 1.0
//    }
//    
//    //MARK: - UITableView methods
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        Debug.logVerbose("Creating cell for row \(indexPath.row)")
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(basicCellID, forIndexPath: indexPath)
//        
//        configureCell(cell, forComputer: detailComputer, atIndexPath: indexPath)
//        
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return heightForBasicCellAtIndexPath(indexPath)
//    }
//    
//    // MARK: - Private enum for cell layout
//    
//    private enum Sections: Int {
//        case Identifiers = 0
//        case People      = 1
//        case Comments    = 2
//        case TechSpecs   = 3
//    }

    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // Empty implementation
//    }

}
