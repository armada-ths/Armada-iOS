import UIKit

class AddCompanyPropertyTableViewController: UITableViewController {
    
    var values = [String]()
    var property: CompanyProperty!
    var companyFilter: _CompanyFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        values = property.values.filter { !companyFilter[property].contains($0) }
        
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
        companyFilter[property] = companyFilter[property] + [values[indexPath.row]]
        return indexPath
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddCompanyPropertyTableViewCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = values[indexPath.row]
        cell.detailTextLabel?.text = "\(DataDude.numberOfCompaniesContainingValue(values[indexPath.row], forProperty: property) ?? 0)"
        return cell
    }

}
