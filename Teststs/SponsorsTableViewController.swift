//
//  SponsorsTableViewController.swift
//  Teststs
//
//  Created by Paul Griffin on 23/07/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class SponsorsTableViewController: UITableViewController {

    @IBOutlet weak var ericssonLabel: UILabel!
    @IBOutlet weak var strömsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        
        let ericssonText = NSMutableAttributedString()
        
        ericssonText.appendAttributedString(NSAttributedString(string: "Lars-Magnus Ericsson", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]))
        
        ericssonText.appendAttributedString(NSAttributedString(string: " founded Ericsson believing that communication is a basic human need.\n\n", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
        
        ericssonText.appendAttributedString(NSAttributedString(string: "138 years later ", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]))
        
        ericssonText.appendAttributedString(NSAttributedString(string: " our vision is to be the prime driver in an all-communicating world.", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
        
        ericssonLabel.attributedText = ericssonText
        let strömsText = NSMutableAttributedString()
        
        strömsText.appendAttributedString(NSAttributedString(string: "Ströms", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]))
        
        strömsText.appendAttributedString(NSAttributedString(string: " has stood at the forefront of Stockholms fashion scene for over", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
        
        strömsText.appendAttributedString(NSAttributedString(string: " 100 years.", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]))
        
        strömsLabel.attributedText = strömsText
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
        
    }
    


    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
