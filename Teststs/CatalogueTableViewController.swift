import UIKit

class CatalogueTableViewController: UITableViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companies = DataDude.companies
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    
    func updateCompaniesByLetters(companies: [Company]) {
        let stopWatch = StopWatch()
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]) })).sort(<).map { letter in (letter: letter, companies: companies.filter({ $0.name.hasPrefix(letter) })) }
        stopWatch.print("Updating letters")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            companies = CompanyFilter.filteredCompanies
        } else {
            companies = DataDude.companies.filter({ FavoriteCompanies.contains($0.name) })
        }
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
        updateFavoritesUI()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControlDidChange(segmentedControl)
    }
    
    func updateFavoritesUI() {
        if companies.isEmpty {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.font = UIFont.systemFontOfSize(30)
            label.text = segmentedControl.selectedSegmentIndex == 0 ? "No Company Matches\nYour Filter" : "No Favorites"
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
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return companiesByLetters.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companiesByLetters[section].companies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTableViewCell", forIndexPath: indexPath) as! CompanyTableViewCell
        let company = companiesByLetters[indexPath.section].companies[indexPath.row]
        cell.descriptionLabel.text = company.description.substringToIndex(company.description.endIndex.advancedBy(-1))
        cell.descriptionLabel.text = company.name
        cell.workFieldLabel.text = company.primaryWorkField
        if let image = company.image {
            cell.logoImageView.image = image
            cell.companyNameLabel.hidden = true
        } else {
            cell.logoImageView.image = nil
            cell.companyNameLabel.hidden = false
            cell.companyNameLabel.text = company.shortName
        }
        
        cell.firstIcon.hidden = true
        cell.secondIcon.hidden = true
        
        
        let icons = ["Rocket", "Tree", "Leaf"]
        let stuff = [company.isStartup, company.likesEnvironment, company.likesEquality]
        
        cell.secondIcon.hidden = true
        cell.firstIcon.hidden = true
        for i in 0...2 {
            if stuff[i] {
                if cell.firstIcon.hidden {
                    cell.firstIcon.image = UIImage(named: icons[i])
                    cell.firstIcon.hidden = false
                } else {
                    cell.secondIcon.image = UIImage(named: icons[i])
                    cell.secondIcon.hidden = false
                }
            }
        }
        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return companiesByLetters.map { $0.letter }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
    }
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return companiesByLetters[indexPath.section].companies[indexPath.row]
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let companiesPageViewController = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CompaniesPageViewController) {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany
        }
        if let controller = ((segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? CatalogueFilterTableViewController) {
            controller.CompanyFilter = CompanyFilter
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return segmentedControl.selectedSegmentIndex == 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            let company = companiesByLetters[indexPath.section].companies[indexPath.row]
            FavoriteCompanies.remove(company.name)
            companies = DataDude.companies.filter { FavoriteCompanies.contains($0.name) }
            
            updateCompaniesByLetters(companies)
            
            if tableView.numberOfRowsInSection(indexPath.section) == 1 {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: .Fade)
            }
            
            
            updateFavoritesUI()
            tableView.endUpdates()
            
        }
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