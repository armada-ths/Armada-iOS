import UIKit

class CatalogueTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    var highlightedCompany: Company?
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return companiesByLetters[indexPath.section].companies[indexPath.row]
        }
        return nil
    }
    
    func swedishOrdering(x: String, y: String) -> Bool {
        let firstNum = Int(String(x.lowercaseString.substringToIndex(x.startIndex.successor())))
        let secondNum = Int(String(y.lowercaseString.substringToIndex(y.startIndex.successor())))
        if firstNum != nil && secondNum != nil {
            return firstNum < secondNum
        } else if firstNum != nil {
            return false
        } else if secondNum != nil {
            return true
        }
        
        let result = x.compare(y, options: [], range: nil, locale: NSLocale(localeIdentifier: "se"))
        switch result {
        case .OrderedAscending, .OrderedSame:
            return true
        case .OrderedDescending:
            return false
        }
    }

    func updateCompaniesByLetters(companies: [Company]) {
        let stopWatch = StopWatch()
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]).uppercaseString })).sort(swedishOrdering).map { letter in (letter: letter, companies: companies.filter({ $0.name.uppercaseString.hasPrefix(letter) })) }
        stopWatch.print("Updating letters")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refresh()
        registerForPreviewingWithDelegate(self, sourceView: view)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let highlightedIndexPath = tableView.indexPathForRowAtPoint(location),
            let cell = tableView.cellForRowAtIndexPath(highlightedIndexPath) else  { return nil }
        let company = companiesByLetters[highlightedIndexPath.section].companies[highlightedIndexPath.row]
        highlightedCompany = company
        let companyViewController = storyboard!.instantiateViewControllerWithIdentifier("CompanyViewController") as! CompanyViewController
        companyViewController.company = company
        previewingContext.sourceRect = cell.frame
        return companyViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.performSegueWithIdentifier("CompanyPageViewControllerSegue", sender: self)
    }
    
    func refresh(refreshControl: UIRefreshControl? = nil) {
        ArmadaApi.updateCompanies {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                refreshControl?.endRefreshing()
                self.updateCompanies()
                self.tableView.reloadData()
                print("Refreshed")
                
            }
        }
    }
    
    func updateCompanies() {
        var companies = [Company]()
        if segmentedControl.selectedSegmentIndex == 0 {
            companies = CatalogueFilter.filteredCompanies
        } else {
            companies = ArmadaApi.companies.filter({ FavoriteCompanies.contains($0.name) })
        }
        if let searchText = searchBar.text where !searchText.isEmpty {
            companies = companies.filter({ $0.name.lowercaseString.hasPrefix(searchText.lowercaseString)})
        }
        updateCompaniesByLetters(companies)
        showEmptyMessage(companies.isEmpty, message: segmentedControl.selectedSegmentIndex == 0 ? "No Company Matches\nYour Filter" : "No Favorites")
        searchBar.hidden = companies.isEmpty  && (searchBar.text ?? "").isEmpty
    }
    
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        updateCompanies()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateCompanies()
        tableView.reloadData()
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
            cell.companyNameLabel.text = company.name
        }
        
        cell.firstIcon.hidden = true
        cell.secondIcon.hidden = true
        
        let icons = [ArmadaField.Startup, ArmadaField.Sustainability, ArmadaField.Diversity, ArmadaField.ClimateCompensation]
        let stuff = [company.isStartup, company.likesEnvironment, company.likesEquality, company.hasClimateCompensated]
        
        cell.secondIcon.hidden = true
        cell.firstIcon.hidden = true
        cell.thirdIcon.hidden = true
        for i in 0..<stuff.count {
            if stuff[i] {
                if cell.firstIcon.hidden {
                    cell.firstIcon.image = icons[i].image
                    cell.firstIcon.hidden = false
                } else if cell.secondIcon.hidden {
                    cell.secondIcon.image = icons[i].image
                    cell.secondIcon.hidden = false
                } else {
                    cell.thirdIcon.image = icons[i].image
                    cell.thirdIcon.hidden = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let companiesPageViewController = segue.destinationViewController as? CompaniesPageViewController {
            companiesPageViewController.companies = companiesByLetters.flatMap { $0.companies }
            companiesPageViewController.selectedCompany = selectedCompany ?? highlightedCompany
        }
        if let controller = segue.destinationViewController as? CompanyFilterTableViewController {
            controller.CompanyFilter = CatalogueFilter
            controller.CopyFilter = MatchFilter
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // Can only edit when favorite segment is selected
        return segmentedControl.selectedSegmentIndex == 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            let company = companiesByLetters[indexPath.section].companies[indexPath.row]
            FavoriteCompanies.remove(company.name)
            updateCompanies()
            if tableView.numberOfRowsInSection(indexPath.section) == 1 {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: .Fade)
            }
            tableView.endUpdates()
        }
    }
}

extension CatalogueTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateCompanies()
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