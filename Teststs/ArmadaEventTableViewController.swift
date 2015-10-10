import UIKit

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[ArmadaEvent]]> -> Void) {
            ArmadaApi.eventsFromServer { callback($0.map { [$0] }) }
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let armadaEvent = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventNewTableViewCell", forIndexPath: indexPath) as!
            ArmadaEventNewTableViewCell
            
            cell.titleLabel.text = armadaEvent.title
            if let imageUrl = armadaEvent.imageUrl {
                //cell.eventImageView.loadImageFromUrl(imageUrl.absoluteString)
                if let image = images[imageUrl.absoluteString]{
                    cell.eventImageView.image = image
                    cell.eventImageUrl = imageUrl.absoluteString
                } else{
                    cell.eventImageView.image = nil
                    cell.eventImageUrl = imageUrl.absoluteString
                    cell.eventImageView.loadImageFromUrl(imageUrl.absoluteString){
                        if let image = $0{
                            if cell.eventImageUrl == imageUrl.absoluteString{
                                self.images[imageUrl.absoluteString] = image
                            }
                        }
                    }
                }
            }
            cell.dateLabel.text = armadaEvent.startDate.format("d") + "\n" + armadaEvent.startDate.format("MMM")
            cell.descriptionLabel.text = armadaEvent.summary

            
            /*
            let imageNames = ["Armada Run", "The Thesis Proposal", "Theme Lectures", "Enova", "Practical Engineering", "The Internship Pitch", "Armada Talks"]
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell
            
            let titleComponents = armadaEvent.title.componentsSeparatedByString(" ")
            let title = titleComponents.count > 1 ? titleComponents[0..<titleComponents.count-1].joinWithSeparator(" ") : titleComponents.last
            cell.titleLabel.text = title
            cell.title2Label.text = title != titleComponents.last ?titleComponents.last : "Event"
            cell.dayLabel.text = armadaEvent.startDate.format("d")
            cell.monthLabel.text = armadaEvent.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
            if let imageUrl = armadaEvent.imageUrl {
                cell.eventImageView.loadImageFromUrl(imageUrl.absoluteString)
            }
*/
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

        let armadaEvent = dataSource.values[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row]
        if let controller = segue.destinationViewController as? ArmadaEventDetailTableViewController {
            controller.armadaEvent = armadaEvent
        }
        if !readArmadaEvents.contains(armadaEvent.title) {
            readArmadaEvents.append(armadaEvent.title)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedCell()
    }
}
