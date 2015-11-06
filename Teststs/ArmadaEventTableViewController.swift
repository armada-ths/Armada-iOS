import UIKit

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[ArmadaEvent]]> -> Void) {
            ArmadaApi.eventsFromServer { response in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(response.map { [$0] })
                    NSOperationQueue().addOperationWithBlock {
                        NSThread.sleepForTimeInterval(1)
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.scrollToNearestUpcomingEvent()
                        }
                    }

                }
            }
        }
        
        func scrollToNearestUpcomingEvent() {
            var row = 0
            let dateFormat = "yyyy-MM-dd"
            let now = NSDate().format(dateFormat)
            let events = values.flatten()
            for (i, event) in events.enumerate() {
                if event.startDate.format(dateFormat) >= now {
                    row = i
                    break
                }
            }
            
            if row != 0 {
                self.tableViewController?.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: row, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let armadaEvent = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventNewTableViewCell", forIndexPath: indexPath) as! ArmadaEventNewTableViewCell
            cell.titleLabel.text = armadaEvent.title
            cell.dateLabel.text = armadaEvent.startDate.format("d") + "\n" + armadaEvent.startDate.format("MMM")
            cell.descriptionLabel.text = armadaEvent.summary.attributedHtmlString?.string
            if let imageUrl = armadaEvent.imageUrl {
                if let image = images[imageUrl.absoluteString] {
                    cell.eventImageView.image = image
                } else{
                    cell.eventImageView.image = nil
                    imageUrl.getImage() { response in
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            if case .Success(let image) = response {
                                self.images[imageUrl.absoluteString] = image
                                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ArmadaEventNewTableViewCell {
                                    cell.eventImageView.image = image
                                }
                            }
                        }
                    }
                }
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
