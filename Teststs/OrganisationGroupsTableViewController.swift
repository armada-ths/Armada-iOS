import UIKit


extension String {
    func containsWordPrefix(prefix: String) -> Bool {
        for word in self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            if word.lowercaseString.hasPrefix(prefix.lowercaseString) {
                return true
            }
        }
        return false
    }
}

class OrganisationGroupsTableViewController: UITableViewController {

    
    class ArmadaOrganisationGroupsTableViewDataSource: ArmadaTableViewDataSource<ArmadaMember> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        var allOrganisationGroups = [ArmadaGroup]()
        
        var filteredOrganisationGroups: [ArmadaGroup] {
            var matchingOrganisationGroups = [ArmadaGroup]()
            for group in allOrganisationGroups {
                let searchText = (tableViewController as! OrganisationGroupsTableViewController).searchBar.text ?? ""
                if !searchText.isEmpty {
                    if !group.name.containsWordPrefix(searchText) {
                        let members = group.members.filter { $0.name.containsWordPrefix(searchText) || $0.role.containsWordPrefix(searchText) }
                        if !members.isEmpty {
                            matchingOrganisationGroups += [ArmadaGroup(name: group.name, members: members)]
                        }
                        continue
                    }
                }
                matchingOrganisationGroups += [group]
            }
            return matchingOrganisationGroups
        }
        
        override func updateFunc(callback: Response<[[ArmadaMember]]> -> Void) {
            ArmadaApi.organisationGroupsFromServer() { response in
                if case .Success(let organisationGroups) = response {
                    self.allOrganisationGroups = organisationGroups
                }
                callback(response.map { _ in [[]] })
            }
        }
        
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredOrganisationGroups[section].members.count
        }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return filteredOrganisationGroups.count
        }

        
        func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return filteredOrganisationGroups[section].name
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let member = filteredOrganisationGroups[indexPath.section].members[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("OrganisationGroupIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = member.name
            cell.detailTextLabel?.text = member.role
            return cell
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var dataSource: ArmadaOrganisationGroupsTableViewDataSource!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = ArmadaOrganisationGroupsTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
        
        searchBar.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source




    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ArmadaMemberTableViewController,
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
            viewController.member = dataSource.filteredOrganisationGroups[indexPath.section].members[indexPath.row]
        }
    }

}

extension OrganisationGroupsTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
