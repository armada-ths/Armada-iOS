import UIKit

class OrganisationGroupsTableViewController: UITableViewController {

    class ArmadaOrganisationGroupsTableViewDataSource: ArmadaTableViewDataSource<ArmadaMember> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        var allOrganisationGroups = [ArmadaGroup]() {
            didSet {
                OperationQueue.main.addOperation {
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
            (tableViewController as! OrganisationGroupsTableViewController).searchBar.isHidden = allOrganisationGroups.isEmpty
            tableViewController?.showEmptyMessage(filteredOrganisationGroups.isEmpty, message: "No members found")
            
        }
        
        override func updateFunc(_ callback: @escaping (Response<[[ArmadaMember]]>) -> Void) {
            ArmadaApi.organisationGroupsFromServer() { response in
                OperationQueue.main.addOperation {
                    if case .success(let organisationGroups) = response {
                        self.allOrganisationGroups = organisationGroups
                    }
                    callback(response.map { _ in [[]] })
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredOrganisationGroups[section].members.count
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return filteredOrganisationGroups.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return filteredOrganisationGroups[section].name
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let member = filteredOrganisationGroups[(indexPath as NSIndexPath).section].members[(indexPath as NSIndexPath).row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganisationGroupIdentifier", for: indexPath) as! MemberTableViewCell
            cell.nameLabel.text = member.name
            cell.roleLabel.text = member.role
            
            
            cell.memberImageView.image = nil
//            cell.memberImageView.hideEmptyMessage()
//            cell.memberImageView.startActivityIndicator()
//            member.imageUrl.getImage { response in
//                NSOperationQueue.mainQueue().addOperationWithBlock {
//                    cell.memberImageView.stopActivityIndicator()
//                    switch response {
//                    case .Success(let image):
//                        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MemberTableViewCell {
//                            
//                            let imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 2))
//                            
//                            
//                            cell.memberImageView.image = UIImage(CGImage: imageRef!)
//                        }
//                    case .Error(let _):
//                        cell.memberImageView.showEmptyMessage("Could not load image", fontSize: 8)
//                        
//                    }
//                }
//            }
            return cell
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataSource: ArmadaOrganisationGroupsTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        let dataSource = ArmadaOrganisationGroupsTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.values.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ArmadaMembersPageViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                searchBar.resignFirstResponder()
                viewController.selectedMember = dataSource.filteredOrganisationGroups[(indexPath as NSIndexPath).section].members[(indexPath as NSIndexPath).row]
                viewController.members = dataSource.filteredOrganisationGroups.flatMap { $0.members }
                deselectSelectedCell()
        }
    }
}

extension OrganisationGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.updateFilter()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        dataSource.updateFilter()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = !(searchBar.text ?? "").isEmpty
    }
}
