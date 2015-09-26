import UIKit

public struct Sponsor {
    let name: String
    let imageUrl: NSURL
    let description: String
    let websiteUrl: NSURL
}

class NewSponsorsTableViewController: UITableViewController {
    
    class ArmadaSponsorTableViewDataSource: ArmadaTableViewDataSource<Sponsor> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[Sponsor]> -> Void) {
            ArmadaApi.sponsorsFromServer(callback)
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let sponsor = values[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(sponsor.description.isEmpty ? "NewSponsorsTableViewCellNoText" : "NewSponsorsTableViewCell") as! NewSponsorsTableViewCell
            if !sponsor.description.isEmpty {
                cell.sponsorLabel.text = sponsor.description
                cell.sponsorLabel.attributedText = sponsor.description.attributedHtmlString
            }
            cell.sponsorImageView.loadImageFromUrl(sponsor.imageUrl.absoluteString)
            return cell
        }
    }
    
    var dataSource: ArmadaSponsorTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ArmadaSponsorTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sponsor = dataSource.values[indexPath.row]
        if UIApplication.sharedApplication().canOpenURL(sponsor.websiteUrl) {
            UIApplication.sharedApplication().openURL(sponsor.websiteUrl)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

