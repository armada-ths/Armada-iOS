//
//  ApplyFilterTableViewCell.swift
//  Teststs
//
//  Created by Sami Purmonen on 28/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class ApplyFilterTableViewCell: UITableViewCell {


    @IBOutlet weak var applyFilterSwitch: UISwitch!
    @IBAction func switchChanged(sender: UISwitch) {
        CompanyFilter.applyFilter = sender.on
        controller?.updateTitle()
    }
    
    var controller: CatalogueFilterTableViewController? = nil
}
