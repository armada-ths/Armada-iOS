import UIKit

class MatchTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companiesWithMatchPercentages = [(company: Company, percentage: Double, position: Int)]()
    
    
    var filteredCompaniesWithMatchPercentages = [(company: Company, percentage: Double, position: Int)]()
    var matchPercentages = [Double]()
    var highlightedCompany: Company?
    var highlightedIndexPath: NSIndexPath?
    var label: UILabel?
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return filteredCompaniesWithMatchPercentages[indexPath.row].company
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        registerForPreviewingWithDelegate(self, sourceView: view)
        if FakeMatchFilter.isEmpty {
            FakeMatchFilter[CompanyProperty.WorkFields] = Array(ArmadaApi.workFields[0...3])
            FakeMatchFilter[CompanyProperty.CompanyValues] = Array(ArmadaApi.companyValues[0...2])
            FakeMatchFilter[CompanyProperty.WorkWays] = Array(ArmadaApi.workWays[0...2])
        }
    }
    
    func updateFilteredCompanies() {
        if let searchText = searchBar.text where !searchText.isEmpty {
            filteredCompaniesWithMatchPercentages = companiesWithMatchPercentages.filter { $0.company.name.lowercaseString.hasPrefix(searchText.lowercaseString) }
        } else {
            filteredCompaniesWithMatchPercentages = companiesWithMatchPercentages
        }
        tableView.reloadData()
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            if MatchFilter.isEmpty {
                return nil
            }
            
            guard let highlightedIndexPath = tableView.indexPathForRowAtPoint(location),
                let cell = tableView.cellForRowAtIndexPath(highlightedIndexPath) else  { return nil }
            let companyWithPercentage = filteredCompaniesWithMatchPercentages[highlightedIndexPath.row]
            highlightedCompany = companyWithPercentage.company
            let companyViewController = storyboard!.instantiateViewControllerWithIdentifier("CompanyViewController") as! CompanyViewController
            companyViewController.company = highlightedCompany
            previewingContext.sourceRect = cell.frame
            return companyViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.performSegueWithIdentifier("CompanyPageViewControllerSegue", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.companiesWithMatchPercentages = Array(calculateCompaniesWithMatchPercentages())
        updateFilteredCompanies()
        self.updateFavoritesUI()
        
        let labelTag = 1337
        let overlayTag = 1338
        
        for subview in view.subviews {
            if subview.tag == labelTag || subview.tag == overlayTag {
                subview.removeFromSuperview()
            }
        }
        
        
        filterButton.enabled = !MatchFilter.isEmpty
        filterButton.title = MatchFilter.isEmpty ? nil : "Filter"
        tableView.scrollEnabled = !MatchFilter.isEmpty
        
        if MatchFilter.isEmpty {
            let overlay = UIView(frame: view.frame)
            overlay.alpha = 0.4
            overlay.tag = overlayTag
            overlay.backgroundColor = UIColor.blackColor()
            overlay.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(overlay)
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
            
            let label = UIButton(frame: view.frame)
            label.setTitleColor(UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0.5), forState: .Highlighted)
            label.setTitle("Start Matching", forState: .Normal)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = ColorScheme.armadaGreen
            
            label.titleLabel?.font = UIFont.systemFontOfSize(25)
            
            let layer = label.layer
            layer.cornerRadius = 10
            let topPadding: CGFloat = 25
            let leadingPadding: CGFloat = 25
            label.contentEdgeInsets = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: topPadding, right: leadingPadding)
            
            label.tag = labelTag
            label.addTarget(self, action: "openFilter:", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(label)
            view.bringSubviewToFront(label)
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -64))
        }
        
        self.tableView.reloadData()
    }
    
    func openFilter(sender: AnyObject) {
        performSegueWithIdentifier("FilterSegue", sender: nil)
    }
    
    func calculateCompaniesWithMatchPercentages() -> [(company: Company, percentage: Double, position: Int)] {
        
        let Filter = MatchFilter.isEmpty ? FakeMatchFilter : MatchFilter
        
        var matches = [(company: Company, percentage: Double, position: Int)]()
        for company in ArmadaApi.companies {
            var percentage = 1.0
            for companyProperty in CompanyProperty.All {
                for value in Filter[companyProperty] {
                    if !company[companyProperty].contains(value) {
                        percentage *= companyProperty.penalty
                    }
                }
            }
            for armadaField in Filter.armadaFields {
                if !company.hasArmadaFieldType(armadaField) {
                    percentage *= 0.8
                }
            }
            let zebra = (company: company, percentage: percentage, position: 0)
            matches.append(zebra)
        }
        matches = matches.sort { ($0.percentage == $1.percentage && $0.company.employeesWorld < $1.company.employeesWorld) || $0.percentage > $1.percentage }
        
        for i in 0..<matches.count {
            matches[i].position = i+1
        }
        return matches
        
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
        navigationItem.title = "Match"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCompaniesWithMatchPercentages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        let companyWithMatchPercentage = filteredCompaniesWithMatchPercentages[indexPath.row]
        let matchPercentage = companyWithMatchPercentage.percentage
        let company = companyWithMatchPercentage.company
        cell.descriptionLabel.text = company.description.substringToIndex(company.description.endIndex.advancedBy(-1))
        cell.descriptionLabel.text = "\(companyWithMatchPercentage.position). \(company.name)"
        cell.matchProgressView.setProgress(Float(matchPercentage), animated: false)
        cell.workFieldLabel.text = company.primaryWorkField ?? "Other"
        cell.matchLabel.text = "\(Int(round(matchPercentage * 100)))%"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        searchBar.resignFirstResponder()
        let companies = filteredCompaniesWithMatchPercentages.map { $0.company }
        if let companiesPageViewController = segue.destinationViewController as? CompaniesPageViewController {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany ?? highlightedCompany
        }
        if let controller = segue.destinationViewController as? CompanyFilterTableViewController {
            controller.CompanyFilter = MatchFilter
            controller.CopyFilter = CatalogueFilter
        }
    }
}

extension MatchTableViewController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateFilteredCompanies()
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
