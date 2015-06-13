import UIKit

var selectedArmadaEvent: ArmadaEvent? = nil

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {

    let armadaEvents: [ArmadaEvent] = {
        do {
            return try DataDude.eventsFromServer()
        } catch {
            return []
        }
    }()
    
    var readArmadaEvents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400
        //tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
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
        return armadaEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell

        let armadaEvent = armadaEvents[indexPath.row]
        
        

        let titleComponents = armadaEvent.title.componentsSeparatedByString(" ")
        let title = " ".join(titleComponents[0..<titleComponents.count-1]) + (titleComponents.count > 1 ? "\n" : "") + titleComponents.last!
        
        cell.titleLabel.text = title
//        cell.summaryLabel.text = armadaEvent.summary
        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"

        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
//        cell.isReadLabel.hidden = readArmadaEvents.contains(armadaEvent.title)
        cell.dayLabel.text = dayFormatter.stringFromDate(armadaEvent.startDate)
        cell.monthLabel.text = monthFormatter.stringFromDate(armadaEvent.startDate).uppercaseString
        cell.eventImageView.image = UIImage(named: armadaEvent.title)
//        cell.locationLabel.text = armadaEvent.location
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        selectedArmadaEvent = armadaEvents[tableView.indexPathForSelectedRow!.row]
        if !readArmadaEvents.contains(selectedArmadaEvent!.title) {
            readArmadaEvents.append(selectedArmadaEvent!.title)
        }
        
    }
}
