import UIKit

var selectedArmadaEvent: ArmadaEvent? = nil

class ArmadaEventTableViewController: UITableViewController {

    let armadaEvents = [ArmadaEvent]() //DataDude.eventsFromServer() ?? [ArmadaEvent]()
    var readArmadaEvents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 220
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
        cell.titleLabel.text = armadaEvent.title
        cell.summaryLabel.text = armadaEvent.summary
        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"

        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
        cell.isReadLabel.hidden = contains(readArmadaEvents, armadaEvent.title)
        cell.dayLabel.text = dayFormatter.stringFromDate(armadaEvent.startDate)
        cell.monthLabel.text = monthFormatter.stringFromDate(armadaEvent.startDate).uppercaseString
        
        cell.locationLabel.text = armadaEvent.location
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        selectedArmadaEvent = armadaEvents[tableView.indexPathForSelectedRow()!.row]
        if !contains(readArmadaEvents, selectedArmadaEvent!.title) {
            readArmadaEvents.append(selectedArmadaEvent!.title)
        }
        
    }
}
