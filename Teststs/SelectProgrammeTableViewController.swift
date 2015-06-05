import UIKit

private let programmeTuples = (["All Programmes in Unspecified"] + DataDude.programmes).sorted(<).map({ $0.componentsSeparatedByString(" in ") })
private let headers = Array(Set(programmeTuples.map { $0[0] })).sorted(<)
private let programmes = headers.map { header in programmeTuples.filter({ header == $0[0]}).map({$0[1]}) }

class SelectProgrammeTableViewController: UITableViewController {
    var selectedProgramme: String?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return programmes.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programmes[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectProgrammeTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let program = headers[indexPath.section] + " in " + programmes[indexPath.section][indexPath.row]
        let numJobs = indexPath.section == 0 ? DataDude.companies.count : DataDude.companies.filter({ contains($0.programmes, program) }).count
        cell.textLabel?.text = programmes[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = "\(numJobs)"
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section != 0 {
            selectedProgramme = headers[indexPath.section] + " in " + programmes[indexPath.section][indexPath.row]
        }
        return indexPath
    }
}