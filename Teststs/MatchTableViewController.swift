import UIKit


private let MatchFilter = _CompanyFilter(userDefaultsKey: "MatchFilter")
class MatchTableViewController: UITableViewController {
    
    var companiesWithMatchPercentages = [(company: Company, percentage: Double)]()
    var matchPercentages = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        if DataDude.companies.count >= 10 {
            self.companiesWithMatchPercentages = Array(self.calculateCompaniesWithMatchPercentages()[0..<10]).filter { $0.percentage > 0 }
        }
        self.updateFavoritesUI()
        self.tableView.reloadData()
    }
    
    func calculateCompaniesWithMatchPercentages() -> [(company: Company, percentage: Double)] {
        var matches = [(company: Company, percentage: Double)]()
        for company in DataDude.companies {
            var percentage = 1.0
            for companyProperty in CompanyProperty.All {
                for value in MatchFilter[companyProperty] {
                    if !company[companyProperty].contains(value) {
                        percentage *= companyProperty.penalty
                    }
                }
            }
            let zebra = (company: company, percentage: percentage)
            matches.append(zebra)
        }
        return matches.sort { ($0.percentage == $1.percentage && $0.company.employeesWorld < $1.company.employeesWorld) || $0.percentage > $1.percentage }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
    func updateFavoritesUI() {
        if companiesWithMatchPercentages.isEmpty {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.text = "No Matches"
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
        navigationItem.title = "Top 10 Matches"
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
        return companiesWithMatchPercentages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        
        
        let companyWithMatchPercentage = companiesWithMatchPercentages[indexPath.row]
        let matchPercentage = companyWithMatchPercentage.percentage
        let company = companyWithMatchPercentage.company
        cell.descriptionLabel.text = company.description.substringToIndex(company.description.endIndex.advancedBy(-1))
        cell.descriptionLabel.text = company.name
        
//        cell.matchProgressView.setProgress(0, animated: false)
//        cell.matchProgressView.setProgress(Float(matchPercentage), animated: true)
        NSOperationQueue.mainQueue().addOperationWithBlock{
//            cell.matchProgressView.setProgress(0, animated: false)
            cell.matchProgressView.setProgress(Float(matchPercentage), animated: true)
        }
        
        cell.workFieldLabel.text = company.primaryWorkField ?? "Other"
        
        //        cell.positionLabel.text = "\(indexPath.row+1)"
                cell.matchLabel.text = "\(Int(round(matchPercentage * 100)))%"
        //        cell.matchLabel.hidden = true
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
    
    var companySplitViewController: CompanySplitViewController {
        return (self.splitViewController as? CompanySplitViewController)!
    }
    
    var selectedCompany: Company? = nil
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        print("will select row")
        selectedCompany = companiesWithMatchPercentages[indexPath.row].company
        return indexPath
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to CompaniesPageViewController")
        let companies = companiesWithMatchPercentages.map { $0.company }
        if let companiesPageViewController = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CompaniesPageViewController) {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany
        }
        if let controller = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CatalogueFilterTableViewController) {
            controller.CompanyFilter = MatchFilter
        }
    }
}

