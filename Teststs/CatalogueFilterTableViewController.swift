import UIKit

enum CompanyProperty: Printable {
    case Programmes, JobTypes, Continents, WorkFields
    
    static let All = [Programmes, JobTypes, Continents, WorkFields]
    static let AllPossibleValues = [DataDude.programmes, DataDude.jobTypes, DataDude.continents, DataDude.workFields]
    static let AllSelectedValues = [CompanyFilter.programmes, CompanyFilter.jobTypes, CompanyFilter.continents, CompanyFilter.workFields]

    var description: String {
        switch self {
        case .Programmes: return "Programme"
        case .JobTypes: return "Job Type"
        case .Continents: return "Continent"
        case .WorkFields: return "Work Field"
        }
    }
    
}

func companyPropertyValuesForCompanyType(companyType: Company, #companyProperty: CompanyProperty) -> [String] {
    switch companyProperty {
    case .Programmes: return companyType.programmes
    case .JobTypes: return companyType.jobTypes
    case .Continents: return companyType.continents
    case .WorkFields: return companyType.workFields
    }
}

let CompanyFilter = _CompanyFilter()
class _CompanyFilter {
    
    private init() {}
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    var programmes: [String] {
        get { return Ω["CompanyFilterEducation"] as? [String] ?? [] }
        set {  Ω["CompanyFilterEducation"] = newValue }
    }
    
    var programme: String? {
        get { return Ω["CompanyFilterProgramme"] as? String }
        set {
            Ω["CompanyFilterProgramme"] = newValue
            programmes = newValue != nil ? [newValue!] : []
        }
    }
    
    var jobTypes: [String] {
        get { return Ω["CompanyFilterJobs"] as? [String] ?? [] }
        set { Ω["CompanyFilterJobs"] = newValue }
    }
    
    var continents: [String] {
        get { return Ω["CompanyFilterContinents"] as? [String] ?? [] }
        set { Ω["CompanyFilterContinents"] = newValue }
    }
    
    var workFields: [String] {
        get { return Ω["CompanyFilterWorkFields"] as? [String] ?? [] }
        set { Ω["CompanyFilterWorkFields"] = newValue }
    }
    
    subscript(companyProperty: CompanyProperty) -> [String] {
        get {
            switch companyProperty {
            case .Programmes: return programmes
            case .JobTypes: return jobTypes
            case .Continents: return continents
            case .WorkFields: return workFields
            }
        }
        
        set {
            switch companyProperty {
            case .Programmes: programmes = newValue
            case .JobTypes: jobTypes = newValue
            case .Continents: continents = newValue
            case .WorkFields: workFields = newValue
            }
        }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = DataDude.companies
        for property in CompanyProperty.All {
            let filterValues = self[property]
            if !filterValues.isEmpty {
                filteredCompanies = filteredCompanies.filter { company in
                    !Set(companyPropertyValuesForCompanyType(company, companyProperty: property)).intersect(filterValues).isEmpty
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
        CompanyFilter.programme = nil
        for property in CompanyProperty.All {
            CompanyFilter[property] = []
        }
        companyPropertyValues = [CompanyFilter.programmes, CompanyFilter.jobTypes, CompanyFilter.continents, CompanyFilter.workFields]
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
        companyPropertyValues = [CompanyFilter.programmes, CompanyFilter.jobTypes, CompanyFilter.continents, CompanyFilter.workFields]
        tableView.reloadData()

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CompanyProperty.All.count
    }
    
    var companyPropertyValues = [CompanyFilter.programmes, CompanyFilter.jobTypes, CompanyFilter.continents, CompanyFilter.workFields]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, companyPropertyValues[section].count + (section == 0 ? 0 : 1))
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["I am studying", "I am looking for", "I wanna work in", "I want to work with"][section]
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
            if let zebra = CompanyFilter.programme?.componentsSeparatedByString(" in ") where zebra.count == 2 {
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
            companyPropertyValues = [CompanyFilter.programmes, CompanyFilter.jobTypes, CompanyFilter.continents, CompanyFilter.workFields]
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
                viewController.jobCount = CompanyProperty.AllPossibleValues[indexPath.section].map { value in DataDude.companies.filter({ contains(companyPropertyValuesForCompanyType($0, companyProperty: CompanyProperty.All[indexPath.section]), value) }).count }
                viewController.title = "Add \(CompanyProperty.All[indexPath.section])"
        }
    }
}

class AddCompanyPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}


