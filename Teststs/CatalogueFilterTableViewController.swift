import UIKit

enum CompanyProperty: CustomStringConvertible {
    case Programmes, JobTypes, Continents, WorkFields, CompanyValues, WorkWays
    
    static let All = [Programmes, JobTypes, Continents, WorkFields, CompanyValues, WorkWays]
    
    var values: [String] {
        switch self {
        case .Programmes: return DataDude.programmes
        case .JobTypes: return DataDude.jobTypes
        case .Continents: return DataDude.continents
        case .WorkFields: return DataDude.workFields
        case .CompanyValues: return DataDude.companyValues
        case .WorkWays: return DataDude.workWays
        }
    }
    
    var description: String {
        switch self {
        case .Programmes: return "Programme"
        case .JobTypes: return "Job Type"
        case .Continents: return "Continent"
        case .WorkFields: return "Work Field"
        case .CompanyValues: return "Company Value"
        case .WorkWays: return "Way of Working"
        }
    }
}

extension Company {
    subscript(companyProperty: CompanyProperty) -> [String] {
        switch companyProperty {
        case .Programmes: return programmes.map {$0.programme}
        case .JobTypes: return jobTypes.map {$0.jobType}
        case .Continents: return continents.map {$0.continent}
        case .WorkFields: return workFields.map {$0.workField}
        case .CompanyValues: return companyValues.map {$0.companyValue}
        case .WorkWays: return workWays.map {$0.workWay}
            
        }
    }
    
    func hasArmadaFieldType(armadaFieldType: _DataDude.ArmadaFieldType) -> Bool {
        switch armadaFieldType {
        case .Startup:
            return isStartup
        case .ClimateCompensation:
            return hasClimateCompensated
        case .Diversity:
            return likesEquality
        case .Sustainability:
            return likesEnvironment
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
    
    var armadaFieldTypes: [_DataDude.ArmadaFieldType] {
        get { return (Ω["\(userDefaultsKey)armadaFieldTypes"] as? [String] ?? []).map { _DataDude.ArmadaFieldType(rawValue: $0)! } }
        set { Ω["\(userDefaultsKey)armadaFieldTypes"] = newValue.map { $0.rawValue } }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = DataDude.companies
        for armadaFieldType in armadaFieldTypes {
            filteredCompanies = filteredCompanies.filter { $0.hasArmadaFieldType(armadaFieldType) }
        }
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
    
    
    var description: String {
        var string = ""
        for property in CompanyProperty.All {
            string += "\(property): \(self[property])\n"
        }
        return string
        
    }

}

class CatalogueFilterTableViewController: UITableViewController, CompanyBoolCellDelegate {
    
    var CompanyFilter: _CompanyFilter! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataDude.numberOfCompaniesForPropertyValueMap.isEmpty {
            DataDude.generateMap()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetFilter() {
        for property in CompanyProperty.All {
            CompanyFilter[property] = []
        }
        CompanyFilter.armadaFieldTypes = []
        updateTitle()
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.reloadData()
        }
        
    }
    // MARK: - Table view data source
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(CompanyFilter.description)
        print("VIEW WILL APPEAR")
        updateTitle()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CompanyProperty.All.count + 1 + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == numberOfSectionsInTableView(tableView) - 2 { return armadaFields.count }
        if section == numberOfSectionsInTableView(tableView) - 1 { return 1 }
        return CompanyFilter[CompanyProperty.All[section]].count + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["I am studying", "I am looking for", "I wanna work in", "I want to work with", "I value", "I value ways of working", "", ""][section]
    }
    
    func cellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier)!
    }
    
    func updateTitle() {
        navigationItem.title = "\(CompanyFilter.filteredCompanies.count) of \(DataDude.companies.count) Companies"
    }
    
    let armadaFields = DataDude.armadaFields
    
    
    func armadaFieldType(armadaFieldType: _DataDude.ArmadaFieldType, isOn: Bool) {
        if isOn {
            CompanyFilter.armadaFieldTypes = CompanyFilter.armadaFieldTypes + [armadaFieldType]
        } else {
            CompanyFilter.armadaFieldTypes = CompanyFilter.armadaFieldTypes.filter { $0 != armadaFieldType }
        }
        updateTitle()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == numberOfSectionsInTableView(tableView) - 1 {
            return cellWithIdentifier("resetAllFiltersCell")
        }
        
        if indexPath.section == numberOfSectionsInTableView(tableView) - 2 {
            let cell = cellWithIdentifier("CompanyBoolCell") as! CompanyBoolCell
            let armadaField = armadaFields[indexPath.row]
            cell.titleLabel.text = armadaField.name
            cell.iconImageView.image = armadaField.image
            cell.valueSwitch.on = CompanyFilter.armadaFieldTypes.contains(armadaField.type)
            cell.armadaFieldType = armadaField.type
            cell.delegate = self
            let companies = DataDude.companies.filter { $0.hasArmadaFieldType(armadaField.type) }
            cell.numberOfJobsLabel.text = "\(companies.count)"
            
            return cell
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
        return indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1
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
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) as? AddCompanyPropertyTableViewCell != nil {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("AddPropertySegue", sender: self)
            }
        }
        if indexPath.section == numberOfSectionsInTableView(tableView) - 1 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "Reset All Filters", style: .Destructive, handler: {
                action in
                self.resetFilter()
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                action in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
}

class AddCompanyPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
