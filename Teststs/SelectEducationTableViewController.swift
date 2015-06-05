import UIKit

class SelectEducationTableViewController: UITableViewController {
    
    let headers = Array(Set((["All Programmes in Unspecified"] + DataDude.programmes).map { $0.componentsSeparatedByString(" in ")[0] })).sorted(<)
    var educations = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let programTuples = (["All Programmes in Unspecified"] + DataDude.programmes).sorted({$0 < $1}).map({ $0.componentsSeparatedByString(" in ") })
        educations = headers.map { header in programTuples.filter({ header == $0[0]}).map({$0[1]}) }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return educations.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educations[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectEducationTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let program = headers[indexPath.section] + " in " + educations[indexPath.section][indexPath.row]
        let numJobs = indexPath.section == 0 ? DataDude.companies.count : DataDude.companies.filter({ contains($0.programmes, program) }).count
        cell.textLabel?.text = educations[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = "\(numJobs)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CompanyFilter[.Programmes] = [headers[indexPath.section] + " in " + educations[indexPath.section][indexPath.row]]
        if indexPath.section == 0 {
            CompanyFilter[.Programmes] = []
        }
    }
}