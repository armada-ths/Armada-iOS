import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        companies = DataDude.companies.filter({ FavoriteCompanies.contains($0.name) })
        tableView.reloadData()
        updateFavoritesUI()
        showSelectedCompany()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
        showSelectedCompany()
    }
    
    func updateFavoritesUI() {
        if FavoriteCompanies.isEmpty {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.text = "No Favorites"
            label.textAlignment = .Center
            label.sizeToFit()
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont.systemFontOfSize(30)
            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        navigationItem.title = "\(companies.count) of \(DataDude.companies.count) Companies"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return companies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTableViewCell", forIndexPath: indexPath) as! CompanyTableViewCell
        
        let company = companies[indexPath.row]
        cell.descriptionLabel.text = company.description.substringToIndex(company.description.endIndex.advancedBy(-1))
        cell.descriptionLabel.text = company.name
        
        cell.workFieldLabel.text = company.primaryWorkField ?? "Other"
        if let image = company.image {
            cell.logoImageView.image = image
            cell.companyNameLabel.hidden = true
        } else {
            cell.logoImageView.image = nil
            cell.companyNameLabel.hidden = false
            cell.companyNameLabel.text = company.name
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    var isEditingTableView = false
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        isEditingTableView = true
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if !isEditingTableView {
            return
        }
        isEditingTableView = false
        showSelectedCompany()
    }
    
    func showSelectedCompany() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if self.companySplitViewController.collapsed {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                }
            } else {
                if let company = self.selectedCompany {
                    self.selectedCompany = self.nearestCompany(company, comanies: self.companies)
                }
                if let company = self.selectedCompany,
                    let row = self.companies.indexOf(company) {
                        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: false, scrollPosition: .None)
                        self.performSegueWithIdentifier("FavoritesSegue", sender: self)
                } else {
                    self.performSegueWithIdentifier("FavoritesSegue", sender: self)
                }
            }
            self.updateFavoritesUI()
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            FavoriteCompanies.remove(companies[indexPath.row].name)
            companies = DataDude.companies.filter { FavoriteCompanies.contains($0.name) }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    var companySplitViewController: CompanySplitViewController {
        return (self.splitViewController as? CompanySplitViewController)!
    }
    
    func nearestCompany(company: Company, comanies: [Company]) -> Company? {
        return self.companies.filter({ $0.name <= company.name }).last ?? self.companies.filter({ $0.name > company.name }).first
    }
    
    var selectedCompany: Company? = nil
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        print("will select row")
        selectedCompany = companies[indexPath.row]
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to CompaniesPageViewController")
        if let companiesPageViewController = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CompaniesPageViewController) {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany
        }
    }
}
