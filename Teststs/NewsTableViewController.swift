//
//  NewsTableViewController.swift
//  Teststs
//
//  Created by Paul Griffin on 27/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

var selectedNewsItem:News!

class NewsTableViewController: UITableViewController {
    var readArmadaNews = [String]()
    let news = DataDude.newsFromServer()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 200
        

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
        return news.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        
        let newsItem = news[indexPath.row]
        cell.titleLabel.text = newsItem.title
        cell.descriptionLabel.text = newsItem.content

        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
        cell.descriptionLabel.text = dayFormatter.stringFromDate(newsItem.publishedDate) + " " + monthFormatter.stringFromDate(newsItem.publishedDate)
        
        cell.isReadLabel.hidden = contains(readArmadaNews, newsItem.title)
        
//        cell.dayLabel.text = dayFormatter.stringFromDate(newsItem.publishedDate)
//        cell.monthLabel.text = monthFormatter.stringFromDate(newsItem.publishedDate)
        
        return cell

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        selectedNewsItem = news[tableView.indexPathForSelectedRow()!.row]
        if !contains(readArmadaNews, selectedNewsItem!.title) {
            readArmadaNews.append(selectedNewsItem!.title)
        }
        
        let contentWithoutHtml = NSAttributedString(data: selectedNewsItem.content.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)!.string
        
        selectedArmadaEvent = ArmadaEvent(title: selectedNewsItem.title, summary: contentWithoutHtml, location: "", startDate: selectedNewsItem.publishedDate, endDate: selectedNewsItem.publishedDate, signupLink: "")

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
