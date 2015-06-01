import UIKit

//var selectedCompany: Company?

class CatalogueTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companies = DataDude.companies
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    
    func updateCompaniesByLetters(companies: [Company]) {
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]) })).sorted(<).map { letter in (letter: letter, companies: companies.filter({ $0.name.hasPrefix(letter) })) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        companies = CompanyFilter.filteredCompanies
        navigationItem.title = "\(companies.count) of \(DataDude.companies.count) Companies"
        updateCompaniesByLetters(companies)
        tableView.reloadData()
        updateFavoritesUI()
        
//        performSegueWithIdentifier("CatalogueSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateFavoritesUI() {
        if companies.isEmpty {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.font = UIFont.systemFontOfSize(30)
            label.text = "No Company Matches\nYour Filter"
            label.numberOfLines = 2
            label.textAlignment = .Center
            label.sizeToFit()
            label.textColor = UIColor.lightGrayColor()

            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            searchBar.hidden = true
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            searchBar.hidden = false
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return companiesByLetters.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return companiesByLetters[section].companies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTableViewCell", forIndexPath: indexPath) as! CompanyTableViewCell
        
        let company = companiesByLetters[indexPath.section].companies[indexPath.row]
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
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return companiesByLetters.map { $0.letter }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
    }
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow() {
            return companiesByLetters[indexPath.section].companies[indexPath.row]
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}


extension CatalogueTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            updateCompaniesByLetters(companies)
        } else {
            updateCompaniesByLetters(companies.filter({ $0.name.lowercaseString.hasPrefix(searchText.lowercaseString)}))
        }
        tableView.reloadData()
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