//
//  NewsDetailTableViewController.swift
//  Teststs
//
//  Created by Paul Griffin on 27/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class NewsDetailTableViewController2: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E dd MMMM"
        
        titleLabel.text = selectedNewsItem.title
        dateLabel.text = dateFormatter.stringFromDate(selectedNewsItem.publishedDate)
        
        contentLabel.attributedText = NSAttributedString(data: selectedNewsItem.content.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)
        contentLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class NewsDetailTableViewController: UITableViewController {
    
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
        cell.titleLabel.text = selectedNewsItem!.title
        
        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
        cell.dayLabel.text = dayFormatter.stringFromDate(selectedNewsItem!.publishedDate)
        cell.monthLabel.text = monthFormatter.stringFromDate(selectedNewsItem!.publishedDate).uppercaseString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E dd MMMM"
        //        cell.dateLabel.text = dateFormatter.stringFromDate(selectedArmadaEvent!.startDate)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
//        cell.locationLabel.text = selectedNewsItem!.location + ", " + timeFormatter.stringFromDate(selectedArmadaEvent!.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent!.endDate)
        //        cell.timeLabel.text = timeFormatter.stringFromDate(selectedArmadaEvent!.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent!.endDate)
        
        cell.summaryLabel.text = selectedNewsItem!.content
        
        cell.summaryLabel.attributedText = NSAttributedString(data: selectedNewsItem.content.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)
        cell.summaryLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
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