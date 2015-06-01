//
//  SelectEducationTableViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 28/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit



class SelectEducationTableViewController: UITableViewController {
    
    
    //    let educations = [
    //        "Computer Science",
    //        "Industrial Management",
    //        "Biotechnology",
    //        "Physics",
    //        "Electro"
    //    ]
    
    
    let headers = Array(Set((["All Programmes in Unspecified"] + DataDude.programmes).map { $0.componentsSeparatedByString(" in ")[0] })).sorted({$0 < $1})
    var educations = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let programTuples = (["All Programmes in Unspecified"] + DataDude.programmes).sorted({$0 < $1}).map({ $0.componentsSeparatedByString(" in ") })
        educations = headers.map { header in programTuples.filter({ header == $0[0]}).map({$0[1]}) }
        updateAccessories()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return educations.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return educations[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectEducationTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let program = headers[indexPath.section] + " in " + educations[indexPath.section][indexPath.row]
        let numJobs = DataDude.companies.filter({ contains($0.programmes, program) }).count
        cell.textLabel?.text = educations[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = "\(numJobs)"
//        cell.textLabel?.font = UIFont.systemFontOfSize(11)
//        cell.detailTextLabel?.font = UIFont.systemFontOfSize(11)
        cell.accessoryType = program == CompanyFilter.education ? .None : .None
        return cell
    }
    
    func updateAccessories() {
        for i in 0..<tableView.numberOfSections() {
            for j in 0..<tableView.numberOfRowsInSection(i) {
                let program = headers[i] + " in " + educations[i][j]
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))?.accessoryType = program == CompanyFilter.education ? .None : .None
            }
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CompanyFilter.education = headers[indexPath.section] + " in " + educations[indexPath.section][indexPath.row]
        updateAccessories()
    }

    
}
