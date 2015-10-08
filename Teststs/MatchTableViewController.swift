import UIKit


private let MatchFilter = _CompanyFilter(userDefaultsKey: "MatchFilter")
private let FakeMatchFilter = _CompanyFilter(userDefaultsKey: "FakeMatchFilter")

class MatchTableViewController: UITableViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var companiesWithMatchPercentages = [(company: Company, percentage: Double)]()
    var matchPercentages = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FakeMatchFilter.isEmpty {
            FakeMatchFilter[CompanyProperty.WorkFields] = Array(ArmadaApi.workFields[0...3])
            FakeMatchFilter[CompanyProperty.CompanyValues] = Array(ArmadaApi.companyValues[0...2])
            FakeMatchFilter[CompanyProperty.WorkWays] = Array(ArmadaApi.workWays[0...2])
        }
    }
    
    var label: UILabel?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let companiesWithMatchPercentages = calculateCompaniesWithMatchPercentages().filter { $0.percentage > 0 }
        self.companiesWithMatchPercentages = Array(companiesWithMatchPercentages[0..<min(10, companiesWithMatchPercentages.count)])
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
            view.addSubview(overlay)
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: overlay, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
            
            let label = UIButton(frame: view.frame)
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
    
    func calculateCompaniesWithMatchPercentages() -> [(company: Company, percentage: Double)] {
        
        
        
        let Filter = MatchFilter.isEmpty ? FakeMatchFilter : MatchFilter
        
        var matches = [(company: Company, percentage: Double)]()
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
        NSOperationQueue.mainQueue().addOperationWithBlock{
            cell.matchProgressView.setProgress(Float(matchPercentage), animated: true)
        }
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
    
    var selectedCompany: Company? = nil
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        print("will select row")
        selectedCompany = companiesWithMatchPercentages[indexPath.row].company
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to CompaniesPageViewController")
        let companies = companiesWithMatchPercentages.map { $0.company }
        if let companiesPageViewController = segue.destinationViewController as? CompaniesPageViewController {
            companiesPageViewController.companies = companies
            companiesPageViewController.selectedCompany = selectedCompany
        }
        if let controller = segue.destinationViewController as? CatalogueFilterTableViewController {
            controller.CompanyFilter = MatchFilter
        }
    }
}

