import UIKit

public struct Sponsor {
    let name: String
    let imageUrl: NSURL
    let description: String
    let websiteUrl: NSURL
}

class NewSponsorsTableViewController: UITableViewController {
    
    var sponsors = [Sponsor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refresh()
    }
    
    
    func refresh(refreshControl: UIRefreshControl? = nil) {
        NSOperationQueue().addOperationWithBlock {
            if let sponsors = try? DataDude.sponsorsFromServer() {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.sponsors = sponsors
                    self.tableView.reloadData()
                    self.showEmptyMessage(self.sponsors.isEmpty, message: "No Sponsors")
                    refreshControl?.endRefreshing()
                    print("Refreshed")
                }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    refreshControl?.endRefreshing()
                    self.showEmptyMessage(self.sponsors.isEmpty, message: "Could not load sponsors")
                    print("Refreshed")
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sponsor = sponsors[indexPath.row]
        if UIApplication.sharedApplication().canOpenURL(sponsor.websiteUrl) {
            UIApplication.sharedApplication().openURL(sponsor.websiteUrl)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sponsor = sponsors[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(sponsor.description.isEmpty ? "NewSponsorsTableViewCellNoText" : "NewSponsorsTableViewCell") as! NewSponsorsTableViewCell
        if !sponsor.description.isEmpty {
            cell.sponsorLabel.text = sponsor.description
            cell.sponsorLabel.attributedText = sponsor.description.attributedHtmlString
        }
        
        cell.sponsorImageView.loadImageFromUrl(sponsor.imageUrl.absoluteString)
        return cell
    }

}
