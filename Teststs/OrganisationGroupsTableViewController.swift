import UIKit


extension String {
    func containsWordPrefix(prefix: String) -> Bool {
        let words = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).map { $0.lowercaseString }
        let searchWords = prefix.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({ !$0.isEmpty}).map { $0.lowercaseString }
        for searchPrefix in searchWords {
            if words.filter({ $0.hasPrefix(searchPrefix) }).isEmpty {
                return false
            }
        }
        return true
    }
}

class OrganisationGroupsTableViewController: UITableViewController {

    
    class ArmadaOrganisationGroupsTableViewDataSource: ArmadaTableViewDataSource<ArmadaMember> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        var allOrganisationGroups = [ArmadaGroup]() {
            didSet {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                self.updateFilter()
                }

            }
        }
        
        var filteredOrganisationGroups = [ArmadaGroup]()
        
        func updateFilter() {
            let stopWatch = StopWatch()
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
            stopWatch.print("Filtered organisations")
            filteredOrganisationGroups = matchingOrganisationGroups
            tableViewController?.tableView.reloadData()
            (tableViewController as! OrganisationGroupsTableViewController).searchBar.hidden = allOrganisationGroups.isEmpty
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
            let cell = tableView.dequeueReusableCellWithIdentifier("OrganisationGroupIdentifier", forIndexPath: indexPath) as! MemberTableViewCell
            cell.nameLabel.text = member.name
            cell.roleLabel.text = member.role
            return cell
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var dataSource: ArmadaOrganisationGroupsTableViewDataSource!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.hidden = true
        let dataSource = ArmadaOrganisationGroupsTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
        searchBar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ArmadaMemberTableViewController,
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
            viewController.member = dataSource.filteredOrganisationGroups[indexPath.section].members[indexPath.row]
            deselectSelectedCell()
        }
    }

}

extension OrganisationGroupsTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.updateFilter()
    }
}
