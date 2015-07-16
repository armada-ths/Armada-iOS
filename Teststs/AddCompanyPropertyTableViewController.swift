import UIKit

class AddCompanyPropertyTableViewController: UITableViewController {
    
    var values = [String]()
    var selectedValue: String?
    var jobCount = [Int]()
    var property: CompanyProperty!

    override func viewDidLoad() {
        super.viewDidLoad()
        values = property.values.filter { !CompanyFilter[property].contains($0) }
        jobCount = property.values.map { value in DataDude.companies.filter({ ($0[property]).contains(value) }).count }
        title = "Add \(property)"
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AddCompanyPropertyTableViewCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = values[indexPath.row]
        cell.detailTextLabel?.text = "\(jobCount[indexPath.row])"
        return cell
    }

}
