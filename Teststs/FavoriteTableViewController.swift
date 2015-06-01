import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var companies = [Company]() {
        didSet {
            //            performSegueWithIdentifier("FavoritesSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateFavorites() {
        companies = DataDude.companies.filter { contains(FavoriteCompanies, $0.name) }
        navigationItem.title = "\(companies.count) of \(DataDude.companies.count) Companies"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateFavorites()
        updateFavoritesUI()
        tableView.reloadData()
        showSelectedCompany()
        
        //        clearsSelectionOnViewWillAppear = false
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
        cell.descriptionLabel.text = company.description.substringToIndex(advance(company.description.endIndex,-1))
        
        cell.descriptionLabel.text = company.name
        
        cell.workFieldLabel.text = company.workFields.first ?? "Other"
        if let image = company.image {
            cell.logoImageView.image = image
            cell.companyNameLabel.hidden = true
        } else {
            cell.logoImageView.image = nil
            cell.companyNameLabel.hidden = false
            cell.companyNameLabel.text = company.shortName
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
        updateFavoritesUI()
        showSelectedCompany()
        println("Ended Editing! \(indexPath.row)")
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            FavoriteCompanies.remove(companies[indexPath.row].name)
            companies = DataDude.companies.filter { contains(FavoriteCompanies, $0.name) }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        
    }
    
    func showSelectedCompany() {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if let company = self.lastCompany,
                    let nearestCompany = self.companies.filter({ $0.name <= company.name }).last ?? self.companies.filter({ $0.name > company.name }).first,
                    let row = find(self.companies, nearestCompany) {
                        println("Last company: \(company.name), Nearest company: \(nearestCompany.name), Row: \(row)")
                        self.lastCompany = nearestCompany
                        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: false, scrollPosition: .None)
                        if company != nearestCompany {
                            self.performSegueWithIdentifier("FavoritesSegue", sender: self)
                        }
                }
            }
    }
    
    
    
    
    var lastCompany: Company? = nil
    //    var lastIndexPath: NSIndexPath? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastCompany = companies[indexPath.row]
        println("Selected \(lastCompany?.name)")
        //        self.performSegueWithIdentifier("FavoritesSegue", sender: self)
    }
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow() {
            return companies[indexPath.row]
        }
        return nil
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let companiesPageViewController = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CompaniesPageViewController) {
            companiesPageViewController.companies = companies
            if let indexPath = tableView.indexPathForSelectedRow() {
                companiesPageViewController.selectedCompany = selectedCompany
            }
            (splitViewController as? CompanySplitViewController)?.shouldCollapse = false
        }
    }
}
