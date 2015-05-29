import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var companies = DataDude.companies

    
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    
    func updateCompaniesByLetters(companies: [Company]) {
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]) })).sorted(<).map { letter in (letter: letter, companies: companies.filter({ $0.name.hasPrefix(letter) })) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateFavorites() {
        companies = DataDude.companies.filter { contains(FavoriteCompanies, $0.name) }
        updateCompaniesByLetters(companies)
        navigationItem.title = "\(companies.count) of \(DataDude.companies.count) companies"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        println("Favorites: \(FavoriteCompanies.count)")
        for company in FavoriteCompanies {
            println(company)
        }
        
        updateFavorites()
        updateFavoritesUI()
        
        tableView.reloadData()
    }
    
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
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            FavoriteCompanies.remove(companiesByLetters[indexPath.section].companies[indexPath.row].name)
            let deleteSection = companiesByLetters[indexPath.section].companies.count == 1
            tableView.beginUpdates()
            updateFavorites()
            if deleteSection {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: FavoriteCompanies.isEmpty ? .None : .Fade)
                if FavoriteCompanies.isEmpty {
                    updateFavoritesUI()
                }
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            tableView.endUpdates()
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            selectedCompany = companiesByLetters[indexPath.section].companies[indexPath.row]
        }
        (segue.destinationViewController as? CompaniesPageViewController)?.companies = companies
    }
}
