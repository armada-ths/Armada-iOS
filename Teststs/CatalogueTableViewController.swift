import UIKit

var selectedCompany: Company?

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
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

            companies = CompanyFilter.applyFilter ? CompanyFilter.filteredCompanies : DataDude.companies
            navigationItem.title = "\(companies.count) of \(DataDude.companies.count) companies"
            updateCompaniesByLetters(companies)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        cell.workFieldLabel.text = company.workFields.first
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            selectedCompany = companiesByLetters[indexPath.section].companies[indexPath.row]
        }
        (segue.destinationViewController as? CompaniesPageViewController)?.companies = companies
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