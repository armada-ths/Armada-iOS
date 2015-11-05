import UIKit

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[ArmadaEvent]]> -> Void) {
            ArmadaApi.eventsFromServer {
                callback($0.map { [$0] })
                
                var row = 0
                let dateFormat = "yyyy-MM-dd"
                let now = NSDate().format(dateFormat)
                if case .Success(let events) = $0 {
                    for (i, event) in events.enumerate() {
                        if event.startDate.format(dateFormat) >= now {
                            row = i
                            break
                        }
                    }
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    if row != 0 {
                        self.tableViewController?.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: row, inSection: 0), atScrollPosition: .Top, animated: true)
                    }
                }
            }
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let armadaEvent = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventNewTableViewCell", forIndexPath: indexPath) as!
            ArmadaEventNewTableViewCell
            
            cell.titleLabel.text = armadaEvent.title
            if let imageUrl = armadaEvent.imageUrl {
                if let image = images[imageUrl.absoluteString]{
                    cell.eventImageView.image = image
                    cell.eventImageUrl = imageUrl.absoluteString
                } else{
                    cell.eventImageView.image = nil
                    cell.eventImageUrl = imageUrl.absoluteString
                    cell.eventImageView.loadImageFromUrl(imageUrl.absoluteString){
                        if case .Success(let image) = $0 {
                            if cell.eventImageUrl == imageUrl.absoluteString{
                                self.images[imageUrl.absoluteString] = image
                            }
                        }
                    }
                }
            }
            cell.dateLabel.text = armadaEvent.startDate.format("d") + "\n" + armadaEvent.startDate.format("MMM")
            cell.descriptionLabel.text = armadaEvent.summary.attributedHtmlString?.string
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
        if let controller = segue.destinationViewController as? ArmadaEventDetailTableViewController,
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let armadaEvent = dataSource.values[indexPath.section][indexPath.row]
                controller.armadaEvent = armadaEvent
                if !readArmadaEvents.contains(armadaEvent.title) {
                    readArmadaEvents.append(armadaEvent.title)
                }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedCell()
    }
}
