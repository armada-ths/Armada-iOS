import UIKit

enum CompanyProperty: CustomStringConvertible {
    case Programmes, JobTypes, Continents, WorkFields, CompanyValues
    
    static let All = [Programmes, JobTypes, Continents, WorkFields, CompanyValues]
    
    var values: [String] {
        switch self {
        case .Programmes: return DataDude.programmes
        case .JobTypes: return DataDude.jobTypes
        case .Continents: return DataDude.continents
        case .WorkFields: return DataDude.workFields
        case .CompanyValues: return DataDude.companyValues
        }
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

func numberOfCompaniesForPropertyValue(property: CompanyProperty, value: String) -> Int {
    return DataDude.companies.filter({ ($0[property]).contains(value) }).count
}

let CompanyFilter = _CompanyFilter(userDefaultsKey: "CompanyFilter")
class _CompanyFilter {
    
    let userDefaultsKey: String
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    subscript(companyProperty: CompanyProperty) -> [String] {
        get { return Ω["\(userDefaultsKey)\(companyProperty)"] as? [String] ?? [] }
        set { Ω["\(userDefaultsKey)\(companyProperty)"] = newValue }
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
        return filteredCompanies.sort { $0.name < $1.name }
    }
}

class CatalogueFilterTableViewController: UITableViewController {
    
    var CompanyFilter: _CompanyFilter! = nil
    
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

        updateTitle()
        tableView.reloadData()
        
    }
    // MARK: - Table view data source
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR")
        updateTitle()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CompanyProperty.All.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, CompanyFilter[CompanyProperty.All[section]].count + (section == 0 ? 0 : 1))
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["I am studying", "I am looking for", "I wanna work in", "I want to work with", "I value"][section]
    }
    
    func cellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier)!
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
        
        let property = CompanyProperty.All[indexPath.section]
        if indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1 {
            let cell = cellWithIdentifier("CompanyPropertyCell")
            cell.textLabel?.text = CompanyFilter[property][indexPath.row]
            cell.detailTextLabel?.text = "\(numberOfCompaniesForPropertyValue(property, value: CompanyFilter[property][indexPath.row]))"
            return cell
        } else {
            let cell = cellWithIdentifier("AddPropertyCell") as! AddCompanyPropertyTableViewCell
            cell.addButton.setTitle("Add \(property)", forState: .Normal)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section > 0 && indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let property = CompanyProperty.All[indexPath.section]
            let value = CompanyFilter[property][indexPath.row]
            CompanyFilter[property] = CompanyFilter[property].filter { $0 != value }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            updateTitle()

        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.destinationViewController)
        if let viewController = (segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? AddCompanyPropertyTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
                viewController.property = CompanyProperty.All[indexPath.section]
                viewController.companyFilter = CompanyFilter
        }
        if let viewController = segue.destinationViewController as? SelectProgrammeTableViewController {
            viewController.CompanyFilter = CompanyFilter
        }
    }
}

class AddCompanyPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
