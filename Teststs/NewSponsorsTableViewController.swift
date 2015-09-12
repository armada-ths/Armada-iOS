import UIKit

public struct Sponsor {
    let name: String
    let imageUrl: NSURL
    let description: String
    
}

class NewSponsorsTableViewController: UITableViewController {
    
    var sponsors = [Sponsor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sponsors = (try? DataDude.sponsorsFromServer()) ?? []
        tableView.reloadData()
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewSponsorsTableViewCell") as! NewSponsorsTableViewCell
        let sponsor = sponsors[indexPath.row]
        cell.sponsorLabel.text = sponsor.description
        if let data = NSData(contentsOfURL: sponsor.imageUrl),
            let image = UIImage(data: data) {
            cell.sponsorImageView.image = image
        }
        return cell
    }

}
