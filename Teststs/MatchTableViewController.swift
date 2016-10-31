import UIKit

class MatchTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var companiesWithMatchPercentages = [(company: Company, percentage: Double, position: Int)]()
    
    
    var filteredCompaniesWithMatchPercentages = [(company: Company, percentage: Double, position: Int)]()
    var matchPercentages = [Double]()
    var highlightedCompany: Company?
    var highlightedIndexPath: IndexPath?
    var label: UILabel?
    
    var selectedCompany: Company? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return filteredCompaniesWithMatchPercentages[(indexPath as NSIndexPath).row].company
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        registerForPreviewing(with: self, sourceView: view)
        if FakeMatchFilter.isEmpty {
            FakeMatchFilter[CompanyProperty.workFields] = Array(ArmadaApi.workFields[0...3])
            FakeMatchFilter[CompanyProperty.companyValues] = Array(ArmadaApi.companyValues[0...2])
            FakeMatchFilter[CompanyProperty.workWays] = Array(ArmadaApi.workWays[0...2])
        }
    }
    
    func updateFilteredCompanies() {
        if let searchText = searchBar.text , !searchText.isEmpty {
            filteredCompaniesWithMatchPercentages = companiesWithMatchPercentages.filter { $0.company.name.lowercased().hasPrefix(searchText.lowercased()) }
        } else {
            filteredCompaniesWithMatchPercentages = companiesWithMatchPercentages
        }
        showEmptyMessage(filteredCompaniesWithMatchPercentages.isEmpty, message: "No companies found")
        tableView.reloadData()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            if MatchFilter.isEmpty {
                return nil
            }
            
            guard let highlightedIndexPath = tableView.indexPathForRow(at: location),
                let cell = tableView.cellForRow(at: highlightedIndexPath) else  { return nil }
            let companyWithPercentage = filteredCompaniesWithMatchPercentages[(highlightedIndexPath as NSIndexPath).row]
            highlightedCompany = companyWithPercentage.company
            let companyViewController = storyboard!.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
            companyViewController.company = highlightedCompany
            previewingContext.sourceRect = cell.frame
            return companyViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.performSegue(withIdentifier: "CompanyPageViewControllerSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        
        filterButton.isEnabled = !MatchFilter.isEmpty
        filterButton.title = MatchFilter.isEmpty ? nil : "Filter"
        tableView.isScrollEnabled = !MatchFilter.isEmpty
        
        if MatchFilter.isEmpty {
            let overlay = UIView(frame: view.frame)
            overlay.alpha = 0.4
            overlay.tag = overlayTag
            overlay.backgroundColor = UIColor.black
            overlay.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(overlay)
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
            
            let label = UIButton(frame: view.frame)
            label.setTitleColor(UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0.5), for: .highlighted)
            label.setTitle("Start Matching", for: UIControlState())
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = ColorScheme.armadaGreen
            
            label.titleLabel?.font = UIFont.systemFont(ofSize: 25)
            
            let layer = label.layer
            layer.cornerRadius = 10
            let topPadding: CGFloat = 25
            let leadingPadding: CGFloat = 25
            label.contentEdgeInsets = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: topPadding, right: leadingPadding)
            
            label.tag = labelTag
            label.addTarget(self, action: #selector(MatchTableViewController.openFilter(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(label)
            view.bringSubview(toFront: label)
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -64))
        }
        
        self.tableView.reloadData()
    }
    
    func openFilter(_ sender: AnyObject) {
        performSegue(withIdentifier: "FilterSegue", sender: nil)
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
        matches = matches.sorted { ($0.percentage == $1.percentage && $0.company.employeesWorld < $1.company.employeesWorld) || $0.percentage > $1.percentage }
        
        for i in 0..<matches.count {
            matches[i].position = i+1
        }
        return matches
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {}
    
    func updateFavoritesUI() {
        if companiesWithMatchPercentages.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            label.text = "No Matches"
            label.textAlignment = .center
            label.sizeToFit()
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 30)
            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        navigationItem.title = "Match"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCompaniesWithMatchPercentages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as! MatchTableViewCell
        let companyWithMatchPercentage = filteredCompaniesWithMatchPercentages[(indexPath as NSIndexPath).row]
        let matchPercentage = companyWithMatchPercentage.percentage
        let company = companyWithMatchPercentage.company
        cell.descriptionLabel.text = company.description.substring(to: company.description.characters.index(company.description.endIndex, offsetBy: -1))
        cell.descriptionLabel.text = "\(companyWithMatchPercentage.position). \(company.name)"
        cell.matchProgressView.setProgress(Float(matchPercentage), animated: false)
        cell.workFieldLabel.text = company.primaryWorkField ?? "Other"
        cell.matchLabel.text = "\(Int(round(matchPercentage * 100)))%"
        if let image = company.image {
            cell.logoImageView.image = image
            cell.companyNameLabel.isHidden = true
        } else {
            cell.logoImageView.image = nil
            cell.companyNameLabel.isHidden = false
            cell.companyNameLabel.text = company.name
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.resignFirstResponder()
        let companies = filteredCompaniesWithMatchPercentages.map { $0.company }
        if let companiesPageViewController = segue.destination as? CompaniesPageViewController {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany ?? highlightedCompany
        }
        if let controller = segue.destination as? CompanyFilterTableViewController {
            controller.CompanyFilter = MatchFilter
            controller.CopyFilter = CatalogueFilter
        }
    }
}

extension MatchTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFilteredCompanies()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        updateFilteredCompanies()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = !(searchBar.text ?? "").isEmpty
    }
}
