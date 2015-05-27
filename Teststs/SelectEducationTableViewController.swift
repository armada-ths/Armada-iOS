//
//  SelectEducationTableViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 28/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

let CompanyFilter = _CompanyFilter()
class _CompanyFilter {
    
    private init() {}
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    var education: String? {
        get { return Ω["CompanyFilterEducation"] as? String }
        set {  Ω["CompanyFilterEducation"] = newValue }
    }
}

class SelectEducationTableViewController: UITableViewController {

    
    let educations = [
        "Computer Science",
        "Industrial Management",
        "Biotechnology",
        "Physics",
        "Electro"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CompanyFilter.education == nil {
            CompanyFilter.education = educations[0]
        }
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return educations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectEducationTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = educations[indexPath.row]
        return cell
    }
    
    func updateAccessories() {
        for i in 0..<tableView.numberOfRowsInSection(0) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))?.accessoryType = educations[i] == CompanyFilter.education ? .Checkmark : .None
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CompanyFilter.education = educations[indexPath.row]
        updateAccessories()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
