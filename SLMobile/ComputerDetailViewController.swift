//
//  ComputerDetailViewController.swift
//  ServiceLink Mobile
//
//  Created by Van Halsema, Gerard on 10/30/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

class ComputerDetailViewController: UITableViewController {
    
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
    var detailItem: SLItem!
    
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
        assignOptionalValueForLabel(assetTagLabel, value: detailComputer[SLKey.Field.AssetTag])
        assignOptionalValueForLabel(serialNumberLabel, value: detailComputer[.SerialNumber])
        assignOptionalValueForLabel(assignedToLabel, value: detailComputer[.AssignedToFullname])
        assignOptionalValueForLabel(locationLabel, value: detailComputer[.Location])
        assignOptionalValueForLabel(ownedByDepartmentLabel, value: detailComputer[.Department])
        assignOptionalValueForLabel(commentsLabel, value: detailComputer[.Comments])
        assignOptionalValueForLabel(modelLabel, value: detailComputer[.ModelID])
        assignOptionalValueForLabel(macAddressLabel, value: detailComputer[.MacAddress])
        assignOptionalValueForLabel(manufacturerLabel, value: detailComputer[.Manufacturer])
        assignOptionalValueForLabel(placeholderLabel, value: detailComputer[.InstallStatus])
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
