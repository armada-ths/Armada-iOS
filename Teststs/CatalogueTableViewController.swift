import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class CatalogueTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    var highlightedCompany: Company?
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return companiesByLetters[(indexPath as NSIndexPath).section].companies[(indexPath as NSIndexPath).row]
        }
        return nil
    }
    
    func swedishOrdering(_ x: String, y: String) -> Bool {
        let firstNum = Int(String(x.lowercased().substring(to: x.characters.index(after: x.startIndex))))
        let secondNum = Int(String(y.lowercased().substring(to: y.characters.index(after: y.startIndex))))
        if firstNum != nil && secondNum != nil {
            return firstNum < secondNum
        } else if firstNum != nil {
            return false
        } else if secondNum != nil {
            return true
        }
        
        let result = x.compare(y, options: [], range: nil, locale: Locale(identifier: "se"))
        switch result {
        case .orderedAscending, .orderedSame:
            return true
        case .orderedDescending:
            return false
        }
    }
    
    func updateCompaniesByLetters(_ companies: [Company]) {
        let stopWatch = StopWatch()
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]).uppercased() })).sorted(by: swedishOrdering).map { letter in (letter: letter, companies: companies.filter({ $0.name.uppercased().hasPrefix(letter) })) }
        stopWatch.print("Updating letters")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
        searchBar.delegate = self
        //        refreshControl = UIRefreshControl()
        //        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refresh()
        registerForPreviewing(with: self, sourceView: view)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let highlightedIndexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: highlightedIndexPath) else  { return nil }
        let company = companiesByLetters[(highlightedIndexPath as NSIndexPath).section].companies[(highlightedIndexPath as NSIndexPath).row]
        highlightedCompany = company
        let companyViewController = storyboard!.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
        companyViewController.company = company
        previewingContext.sourceRect = cell.frame
        return companyViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.performSegue(withIdentifier: "CompanyPageViewControllerSegue", sender: self)
    }
    
    func refresh(_ refreshControl: UIRefreshControl? = nil) {
        ArmadaApi.updateCompanies {
            OperationQueue.main.addOperation {
                refreshControl?.endRefreshing()
                self.updateCompanies()
                self.tableView.reloadData()
                print("Refreshed")
                
            }
        }
    }
    
    func updateCompanies() {
        var companies = [Company]()
            companies = CatalogueFilter.filteredCompanies
        if let searchText = searchBar.text , !searchText.isEmpty {
            companies = companies.filter({ $0.name.lowercased().hasPrefix(searchText.lowercased())})
        }
        updateCompaniesByLetters(companies)
      //  showEmptyMessage(companies.isEmpty, message:  "No company matches\nyour filter")
        searchBar.isHidden = companies.isEmpty  && (searchBar.text ?? "").isEmpty
        tableView.reloadData()
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        updateCompanies()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCompanies()
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {}
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return companiesByLetters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companiesByLetters[section].companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! CompanyTableViewCell
        let company = companiesByLetters[(indexPath as NSIndexPath).section].companies[(indexPath as NSIndexPath).row]
        cell.descriptionLabel.text = company.description.substring(to: company.description.characters.index(company.description.endIndex, offsetBy: -1))
        cell.descriptionLabel.text = company.name
        cell.workFieldLabel.text = company.primaryWorkField
        cell.descriptionLabel.sizeToFit()
        if let image = company.image {
            cell.logoImageView.image = image
            cell.companyNameLabel.isHidden = true
        } else {
            cell.logoImageView.image = nil
            cell.companyNameLabel.isHidden = true
        }
        
        
        //let icons = [ArmadaField.Startup, ArmadaField.Sustainability, ArmadaField.Diversity]
        //let stuff = [company.isStartup, company.likesEnvironment, company.likesEquality]
        
        cell.secondIcon.isHidden = true
        cell.firstIcon.isHidden = true
        cell.thirdIcon.isHidden = true
        /*for i in 0..<stuff.count {
         if stuff[i] {
         if cell.firstIcon.isHidden {
         cell.firstIcon.image = icons[i].image
         cell.firstIcon.isHidden = false
         } else if cell.secondIcon.isHidden {
         cell.secondIcon.image = icons[i].image
         cell.secondIcon.isHidden = false
         } else {
         cell.thirdIcon.image = icons[i].image
         cell.thirdIcon.isHidden = false
         }
         }
         }*/
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return companiesByLetters.map { $0.letter }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.resignFirstResponder()
        if let companiesPageViewController = segue.destination as? CompaniesPageViewController {
            companiesPageViewController.companies = companiesByLetters.flatMap { $0.companies }
            companiesPageViewController.selectedCompany = selectedCompany ?? highlightedCompany
        }
        if let controller = segue.destination as? CompanyFilterTableViewController {
            controller.CompanyFilter = CatalogueFilter
            controller.CopyFilter = MatchFilter
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let company = companiesByLetters[(indexPath as NSIndexPath).section].companies[(indexPath as NSIndexPath).row]
            FavoriteCompanies.remove(company.name)
            updateCompanies()
            if tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section) == 1 {
                tableView.deleteSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath],
                                     with: .fade)
            }
            tableView.endUpdates()
        }
    }
 
}

extension CatalogueTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateCompanies()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        updateCompanies()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = !(searchBar.text ?? "").isEmpty
    }
    
}

