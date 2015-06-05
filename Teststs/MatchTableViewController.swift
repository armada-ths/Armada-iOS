import UIKit

class MatchTableViewController: UITableViewController {
    
    var companies = [Company]()
    var matchPercentages = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        companies = Array(DataDude.companies[0..<10])
        matchPercentages = companies.map({ _ in Double(Int(rand()) % 101) / 100 }).sorted(>)
        updateFavoritesUI()
        tableView.reloadData()
        showSelectedCompany()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
        showSelectedCompany()
    }
        @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        
        let matchPercentage = matchPercentages[indexPath.row]
        
        let company = companies[indexPath.row]
        cell.descriptionLabel.text = company.description.substringToIndex(advance(company.description.endIndex,-1))
        cell.descriptionLabel.text = company.name
        
        cell.matchProgressView.setProgress(0, animated: false)
        cell.matchProgressView.setProgress(Float(matchPercentage), animated: true)
        cell.workFieldLabel.text = company.workFields.first ?? "Other"
        
        cell.positionLabel.text = "\(indexPath.row+1)"
        cell.matchLabel.text = "\(Int(matchPercentage * 100))%"
        cell.matchLabel.hidden = true
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
    
    func showSelectedCompany() {
        
    }
    
    var companySplitViewController: CompanySplitViewController {
        return (self.splitViewController as? CompanySplitViewController)!
    }
    
    func nearestCompany(company: Company, comanies: [Company]) -> Company? {
        return self.companies.filter({ $0.name <= company.name }).last ?? self.companies.filter({ $0.name > company.name }).first
    }
    
    var selectedCompany: Company? = nil
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        println("will select row")
        selectedCompany = companies[indexPath.row]
        return indexPath
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Segue to CompaniesPageViewController")
        if let companiesPageViewController = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CompaniesPageViewController) {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany
        }
    }
}


class MatchTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var workFieldLabel: UILabel!
    @IBOutlet weak var matchProgressView: UIProgressView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    
}

