import UIKit

enum CompanyProperty: Printable {
    case Programmes, JobTypes, Continents, WorkFields, CompanyValues
    
    static let All = [Programmes, JobTypes, Continents, WorkFields, CompanyValues]
    static let AllPossibleValues = [DataDude.programmes, DataDude.jobTypes, DataDude.continents, DataDude.workFields, DataDude.companyValues]
    static var AllSelectedValues: [[String]] {
        return All.map { CompanyFilter[$0] }
    }

    var description: String {
        switch self {
        case .Programmes: return "Programme"
        case .JobTypes: return "Job Type"
        case .Continents: return "Continent"
        case .WorkFields: return "Work Field"
        case .CompanyValues: return "Company Value"
        }
    }
}


extension Company {
    subscript(companyProperty: CompanyProperty) -> [String] {
        switch companyProperty {
        case .Programmes: return programmes
        case .JobTypes: return jobTypes
        case .Continents: return continents
        case .WorkFields: return workFields
        case .CompanyValues: return companyValues
        }
    }
}

let CompanyFilter = _CompanyFilter()
class _CompanyFilter {
    
    private init() {}
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    subscript(companyProperty: CompanyProperty) -> [String] {
        get { return Ω["CompanyFilter" + companyProperty.description] as? [String] ?? [] }
        set { Ω["CompanyFilter" + companyProperty.description] = newValue }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = DataDude.companies
        for property in CompanyProperty.All {
            let filterValues = self[property]
            if !filterValues.isEmpty {
                filteredCompanies = filteredCompanies.filter { company in
                    !Set(company[property]).intersect(filterValues).isEmpty
                }
            }
        }
        return filteredCompanies.sorted { $0.name < $1.name }
    }
}

class CatalogueFilterTableViewController: UITableViewController {
    
    @IBOutlet weak var educationTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetFilter(sender: AnyObject) {
        for property in CompanyProperty.All {
            CompanyFilter[property] = []
        }
        companyPropertyValues = CompanyProperty.AllSelectedValues
        updateTitle()
        tableView.reloadData()
        
    }
    // MARK: - Table view data source
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        println("UNWINDING")
        if let viewController = unwindSegue.sourceViewController as? AddCompanyPropertyTableViewController {
            if let value = viewController.selectedValue,
                let indexPath = lastIndexPath {
                    let property = CompanyProperty.All[indexPath.section]
                    CompanyFilter[property] = CompanyFilter[property] + [value]

            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("VIEW WILL APPEAR")
        updateTitle()
        companyPropertyValues = CompanyProperty.AllSelectedValues
        tableView.reloadData()

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CompanyProperty.All.count
    }

    var companyPropertyValues = CompanyProperty.AllSelectedValues
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, companyPropertyValues[section].count + (section == 0 ? 0 : 1))
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["I am studying", "I am looking for", "I wanna work in", "I want to work with", "I value"][section]
    }
    
    func cellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    }
    
    func updateTitle() {
        navigationItem.title = "\(CompanyFilter.filteredCompanies.count) of \(DataDude.companies.count) Companies"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let specialCell = cellWithIdentifier("SelectedEducationTableViewCell") as! SelectedEducationTableViewCell
            if let zebra = CompanyFilter[.Programmes].first?.componentsSeparatedByString(" in ") where zebra.count == 2 {
                specialCell.fieldLabel.text = zebra[1]
                specialCell.degreeLabel.text = zebra[0]
            } else {
                specialCell.fieldLabel.text = "Unspecified"
                specialCell.degreeLabel.text = "All Programmes"
            }
            
            specialCell.textLabel?.font = UIFont.systemFontOfSize(12)
            return specialCell
        }
        
        
        if indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1 {
            let cell = cellWithIdentifier("CompanyPropertyCell")
            cell.textLabel?.text = companyPropertyValues[indexPath.section][indexPath.row]
            return cell
        } else {
            let cell = cellWithIdentifier("AddPropertyCell") as! AddCompanyPropertyTableViewCell
            
            cell.addButton.setTitle("Add \(CompanyProperty.All[indexPath.section])", forState: .Normal)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section > 0 && indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let property = CompanyProperty.All[indexPath.section]
            let value = companyPropertyValues[indexPath.section][indexPath.row]
            CompanyFilter[property] = CompanyFilter[property].filter { $0 != value }
            companyPropertyValues = CompanyProperty.AllSelectedValues
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            updateTitle()

        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    var lastIndexPath: NSIndexPath? = nil
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.destinationViewController)
        if let viewController = (segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? AddCompanyPropertyTableViewController,
            let indexPath = tableView.indexPathForSelectedRow() {
                lastIndexPath = indexPath
                println("Setting values for seguing")
                viewController.values = CompanyProperty.AllPossibleValues[indexPath.section]
                let companyProperty = CompanyProperty.All[indexPath.section]
                viewController.jobCount = CompanyProperty.AllPossibleValues[indexPath.section].map { value in DataDude.companies.filter({ contains(($0[companyProperty]), value) }).count }
                viewController.title = "Add \(companyProperty)"
        }
    }
}

class AddCompanyPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
