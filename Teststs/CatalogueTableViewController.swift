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
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var cellColours = [ColorScheme.armadaGreen, ColorScheme.armadaRed, ColorScheme.armadaLicorice]
    
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    var companiesArray = Array <Company> ()
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
        companiesArray = companies.sorted(by: ({swedishOrdering($0.name, y: $1.name)}))
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]).uppercased() })).sorted(by: swedishOrdering).map { letter in (letter: letter, companies: companies.filter({ $0.name.uppercased().hasPrefix(letter) })) }
        stopWatch.print("Updating letters")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
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
        let companyViewController = storyboard!.instantiateViewController(withIdentifier: "CompanyView") as! CompanyViewController
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCompanies()
        
        // change backbar button from "Back" to ""
        backBarButton.title = ""
        
        // reveal logo-image
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = false
        
        
        // set title if not set
        if self.navigationItem.titleView == nil {
            
            let frame = CGRect(x: 0,y: 9, width: 240, height: 30);
            let label = UILabel(frame: frame)
            let myMutableString = NSMutableAttributedString(
                string: "C A T A L O G U E THS Armada 2017",
                attributes: [NSFontAttributeName:UIFont(
                    name: "BebasNeue-Light",
                    size: 22.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 18))
            label.textAlignment = .center
            label.attributedText = myMutableString
            let newTitleView = UIView(frame: CGRect(x: 0, y:0 , width: 240, height: 50))
            newTitleView.addSubview(label)
            self.navigationItem.titleView = newTitleView
        }
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
        cell.descriptionLabel.sizeToFit()
        cell.arrow.image = #imageLiteral(resourceName: "wArrow")
        cell.shadow.layer.cornerRadius = 1
        cell.layer.zPosition = CGFloat(companiesByLetters[(indexPath as NSIndexPath).section].companies.count-indexPath.row)
        if (company.localImage != nil){
            let image = company.localImage!
            cell.logoImageView.backgroundColor = UIColor.white
            if(image.size.width > image.size.height){
               cell.imageHeight.constant = 50 * (image.size.height/image.size.width )
                cell.imageWidth.constant = 50
            }
            else{
                cell.imageWidth.constant = 50 * (image.size.width/image.size.height )
                cell.imageHeight.constant = 50
                
            }
            cell.logoImageView.image = image
        }
        else{
            cell.setLogo(company)
        }
        //let icons = [ArmadaField.Startup, ArmadaField.Sustainability, ArmadaField.Diversity]
        //let stuff = [company.isStartup, company.likesEnvironment, company.likesEquality]
     //   cell.descriptionLabel.textColor = UIColor.white
        if (company.likesEnvironment){
            cell.backgroundColor = ColorScheme.sustainabilityGreen
            cell.firstIcon.isHidden = false
            cell.secondIcon.isHidden = true
        }
        else if (company.likesEquality){
            cell.backgroundColor = ColorScheme.diversityRed
            cell.firstIcon.isHidden = true
            cell.secondIcon.isHidden = false
        }
        else{
            cell.descriptionLabel.textColor = UIColor.black
            cell.arrow.image = #imageLiteral(resourceName: "gArrow")
            cell.backgroundColor = UIColor.white
            cell.secondIcon.isHidden = true
            cell.firstIcon.isHidden = true
        }
//        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
//        cell.layer.shadowColor = UIColor.black.cgColor
//        //self.viewBg!.layer.shadowRadius = 4
//        cell.layer.shadowOpacity = 0.25
//        cell.layer.masksToBounds = false;
//        cell.clipsToBounds = false;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return companiesByLetters.map { $0.letter }
//    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return companiesByLetters[section].letter
//    }
    
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
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return companiesByLetters.map { $0.letter }
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
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

