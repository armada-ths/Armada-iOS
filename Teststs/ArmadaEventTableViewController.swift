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
        

        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        splitViewController?.delegate = self
        self.tableView.estimatedRowHeight = 400
         self.clearsSelectionOnViewWillAppear = true
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return armadaEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell
        let armadaEvent = armadaEvents[indexPath.row]
        let titleComponents = armadaEvent.title.componentsSeparatedByString(" ")
        let title = titleComponents.count > 1 ? titleComponents[0..<titleComponents.count-1].joinWithSeparator(" ") : titleComponents.last
        cell.titleLabel.text = title
        cell.title2Label.text = title != titleComponents.last ?titleComponents.last : "Event"
        cell.dayLabel.text = armadaEvent.startDate.format("d")
        cell.monthLabel.text = armadaEvent.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
        cell.eventImageView.image = UIImage(named: armadaEvent.title.stringByReplacingOccurrencesOfString("ä", withString: ""))
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        selectedArmadaEvent = armadaEvents[tableView.indexPathForSelectedRow!.row]
        if !readArmadaEvents.contains(selectedArmadaEvent!.title) {
            readArmadaEvents.append(selectedArmadaEvent!.title)
        }
        
    }
}
