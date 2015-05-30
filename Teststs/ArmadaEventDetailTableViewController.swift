//
//  ArmadaEventDetailTableViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 27/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class ArmadaEventDetailTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 300
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell
        cell.titleLabel.text = selectedArmadaEvent!.title

        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
        cell.dayLabel.text = dayFormatter.stringFromDate(selectedArmadaEvent!.startDate)
        cell.monthLabel.text = monthFormatter.stringFromDate(selectedArmadaEvent!.startDate).uppercaseString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E dd MMMM"
//        cell.dateLabel.text = dateFormatter.stringFromDate(selectedArmadaEvent!.startDate)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        cell.locationLabel.text = selectedArmadaEvent!.location + ", " + timeFormatter.stringFromDate(selectedArmadaEvent!.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent!.endDate)
        
        if selectedArmadaEvent!.location.isEmpty {
            cell.locationLabel.text = timeFormatter.stringFromDate(selectedArmadaEvent!.startDate)
        }
//        cell.timeLabel.text = timeFormatter.stringFromDate(selectedArmadaEvent!.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent!.endDate)
        
        cell.summaryLabel.text = selectedArmadaEvent!.summary
        // Configure the cell...

        return cell
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
