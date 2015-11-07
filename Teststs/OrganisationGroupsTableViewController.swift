import UIKit

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

        override var hasNavigationBar: Bool {
            return false
        }
        
        var filteredOrganisationGroups = [ArmadaGroup]()
        
        func updateFilter() {
            var matchingOrganisationGroups = [ArmadaGroup]()
            for group in allOrganisationGroups {
                let searchText = (tableViewController as! OrganisationGroupsTableViewController).searchBar.text ?? ""
                if searchText.isEmpty {
                    matchingOrganisationGroups += [group]
                } else {
                    if group.name.containsWordWithPrefix(searchText) {
                        matchingOrganisationGroups += [group]
                    } else {
                        let members = group.members.filter { $0.name.containsWordWithPrefix(searchText) || $0.role.containsWordWithPrefix(searchText) }
                        if !members.isEmpty {
                            matchingOrganisationGroups += [ArmadaGroup(name: group.name, members: members)]
                        }
                    }
                }
            }
            filteredOrganisationGroups = matchingOrganisationGroups
            tableViewController?.tableView.reloadData()
            (tableViewController as! OrganisationGroupsTableViewController).searchBar.hidden = allOrganisationGroups.isEmpty
        }
        
        override func updateFunc(callback: Response<[[ArmadaMember]]> -> Void) {
            ArmadaApi.organisationGroupsFromServer() { response in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    if case .Success(let organisationGroups) = response {
                        self.allOrganisationGroups = organisationGroups
                    }
                    callback(response.map { _ in [[]] })
                }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.values.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ArmadaMembersPageViewController,
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                searchBar.resignFirstResponder()
                viewController.selectedMember = dataSource.filteredOrganisationGroups[indexPath.section].members[indexPath.row]
                viewController.members = dataSource.filteredOrganisationGroups.flatMap { $0.members }
                deselectSelectedCell()
        }
    }
}

extension OrganisationGroupsTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.updateFilter()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
