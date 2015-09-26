import UIKit

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[ArmadaEvent]> -> Void) {
            ArmadaApi.eventsFromServer(callback)
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let imageNames = ["Armada Run", "The Thesis Proposal", "Theme Lectures", "Enova", "Practical Engineering", "The Internship Pitch", "Armada Talks"]
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell
            let armadaEvent = values[indexPath.row]
            let titleComponents = armadaEvent.title.componentsSeparatedByString(" ")
            let title = titleComponents.count > 1 ? titleComponents[0..<titleComponents.count-1].joinWithSeparator(" ") : titleComponents.last
            cell.titleLabel.text = title
            cell.title2Label.text = title != titleComponents.last ?titleComponents.last : "Event"
            cell.dayLabel.text = armadaEvent.startDate.format("d")
            cell.monthLabel.text = armadaEvent.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
            if let imageUrl = armadaEvent.imageUrl {
                cell.eventImageView.loadImageFromUrl(imageUrl.absoluteString)
            }
            return cell
        }
    }
    
    var readArmadaEvents = [String]()
    
    var dataSource: ArmadaEventTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ArmadaEventTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        splitViewController?.delegate = self
        self.tableView.estimatedRowHeight = 400
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let armadaEvent = dataSource.values[tableView.indexPathForSelectedRow!.row]
        if let controller = segue.destinationViewController as? ArmadaEventDetailTableViewController {
            controller.armadaEvent = armadaEvent
        }
        if !readArmadaEvents.contains(armadaEvent.title) {
            readArmadaEvents.append(armadaEvent.title)
        }
        
    }
}
