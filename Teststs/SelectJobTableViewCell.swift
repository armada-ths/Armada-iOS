//
//  SelectJobTableViewCell.swift
//  Teststs
//
//  Created by Sami Purmonen on 30/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class SelectJobTableViewCell: UITableViewCell {
    
    weak var controller: CatalogueFilterTableViewController? = nil
    @IBOutlet weak var jobSwitch: UISwitch!
    @IBAction func changedJob(sender: UISwitch) {
        CompanyFilter.jobs = sender.on ? CompanyFilter.jobs + [jobName] : CompanyFilter.jobs.filter { $0 != self.jobName }
        
        controller!.updateTitle()
//        controller!.tableView.reloadData()
    }

    @IBOutlet weak var jobCountLabel: UILabel!
    var jobName = ""
    
    @IBOutlet weak var jobNameLabel: UILabel!
    
}
