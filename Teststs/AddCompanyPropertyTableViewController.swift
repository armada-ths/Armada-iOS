
import UIKit

class AddCompanyPropertyTableViewController: UITableViewController {
    
    var values = [String]()
    var selectedValue: String?
    var jobCount = [Int]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedValue = values[indexPath.row]
        return indexPath
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddCompanyPropertyTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = values[indexPath.row]
        cell.detailTextLabel?.text = "\(jobCount[indexPath.row])"
        return cell
    }

}
