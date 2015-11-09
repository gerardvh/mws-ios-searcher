//
//  ComputerDetailViewController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/30/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class ComputerDetailViewController: UITableViewController, DetailViewController {
    
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
    var detailItem: Any?
    
    var detailComputer: Computer {
        guard let comp = detailItem as? Computer
            else {fatalError("Unable to cast detailComputer")}
        
        return comp
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    // MARK: - Custom setup methods
    
    func configureView() {
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
    
    /**
    Custom method to provide graceful fallback for optional labels.
    
    - parameter label: Label outlet from a storyboard.
    - parameter value: String? with text for the label. Will be replaced with "None" if .None
    */
    private func assignOptionalValueForLabel(label: UILabel, value: String?) {
        label.text = value ?? "None"
    }
}
