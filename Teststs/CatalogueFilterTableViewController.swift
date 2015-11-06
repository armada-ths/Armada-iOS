import UIKit

enum CompanyProperty: CustomStringConvertible {
    case Programmes, JobTypes, Continents, WorkFields, CompanyValues, WorkWays
    
    static let All = [Programmes, JobTypes, Continents, WorkFields, CompanyValues, WorkWays]
    
    var penalty: Double {
        switch self {
        case .Programmes: return 0.2
        case .JobTypes: return 0.6
        case .Continents: return 0.9
        case .WorkFields: return 0.4
        case .CompanyValues: return 0.9
        case .WorkWays: return 0.9
        }
    }
    
    var values: [String] {
        switch self {
        case .Programmes: return ArmadaApi.programmes
        case .JobTypes: return ArmadaApi.jobTypes
        case .Continents: return ArmadaApi.continents
        case .WorkFields: return ArmadaApi.workFields
        case .CompanyValues: return ArmadaApi.companyValues
        case .WorkWays: return ArmadaApi.workWays
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
    
    func hasArmadaFieldType(armadaField: ArmadaField) -> Bool {
        switch armadaField {
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
    return ArmadaApi.companies.filter({ ($0[property]).contains(value) }).count
}

let CompanyFilter = _CompanyFilter(userDefaultsKey: "CompanyFilter")
class _CompanyFilter {
    
    let userDefaultsKey: String
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    func copyFilter(filter: _CompanyFilter) {
        for property in CompanyProperty.All {
            self[property] = filter[property]
        }
        self.armadaFields = filter.armadaFields

    }
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    var isEmpty: Bool {
        for property in CompanyProperty.All {
            if !self[property].isEmpty {
                return false
            }
        }
        for field in ArmadaField.All {
            if armadaFields.contains(field) {
                return false
            }
        }
        return true
    }
    
    func reset() {
        for property in CompanyProperty.All {
            self[property] = []
        }
        self.armadaFields = []
    }
    
    subscript(companyProperty: CompanyProperty) -> [String] {
        get { return Ω["\(userDefaultsKey)\(companyProperty)"] as? [String] ?? [] }
        set { Ω["\(userDefaultsKey)\(companyProperty)"] = newValue }
    }
    
    var armadaFields: [ArmadaField] {
        get { return (Ω["\(userDefaultsKey)armadaField"] as? [String] ?? []).map { ArmadaField(rawValue: $0) ?? .Startup } }
        set { Ω["\(userDefaultsKey)armadaField"] = newValue.map { $0.rawValue } }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = ArmadaApi.companies
        for armadaFieldType in armadaFields {
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
        return filteredCompanies
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
    var CopyFilter: _CompanyFilter! = nil
    
    var armadaPages: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArmadaApi.pagesFromServer {
            if case .Success(let armadaPages) = $0 {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                	self.armadaPages = armadaPages
                    self.tableView.reloadData()
                }
            }
        }
        
        if ArmadaApi.numberOfCompaniesForPropertyValueMap.isEmpty {
            ArmadaApi.generateMap()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func copyFilter() {
        CompanyFilter.copyFilter(CopyFilter)
        updateTitle()
        tableView.reloadData()
    }
    
    func resetFilter() {
        CompanyFilter.reset()
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
        if section == numberOfSectionsInTableView(tableView) - 1 { return 2 }
        return CompanyFilter[CompanyProperty.All[section]].count + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Programmes", "Job Types", "Continents", "Work Fields", "Company Values", "Ways of working", "", ""][section]
    }
    
    func cellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier)!
    }
    
    func updateTitle() {
        navigationItem.title = "\(CompanyFilter.filteredCompanies.count) of \(ArmadaApi.companies.count) Companies"
    }
    
    let armadaFields = ArmadaField.All
    
    
    func armadaField(armadaField: ArmadaField, isOn: Bool) {
        if isOn {
            CompanyFilter.armadaFields = CompanyFilter.armadaFields + [armadaField]
        } else {
            CompanyFilter.armadaFields = CompanyFilter.armadaFields.filter { $0 != armadaField }
        }
        updateTitle()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == numberOfSectionsInTableView(tableView) - 1 {
            if indexPath.row == 0 {
                return cellWithIdentifier(CompanyFilter.userDefaultsKey == MatchFilter.userDefaultsKey ? "copyCatalogueCell" : "copyMatchCell")
            } else {
                return cellWithIdentifier("resetAllFiltersCell")
            }
        }
        
        if indexPath.section == numberOfSectionsInTableView(tableView) - 2 {
            let cell = cellWithIdentifier("CompanyBoolCell") as! CompanyBoolCell
            let armadaField = armadaFields[indexPath.row]
            cell.titleLabel.text = armadaPages?[armadaField.rawValue]??["title"] as? String ?? armadaField.title
            cell.iconImageView.image = armadaField.image
            cell.valueSwitch.on = CompanyFilter.armadaFields.contains(armadaField)
            cell.armadaField = armadaField
            cell.delegate = self
            let companies = ArmadaApi.companies.filter { $0.hasArmadaFieldType(armadaField) }
            cell.numberOfJobsLabel.text = "\(companies.count)"
            
            return cell
        }
        
        let property = CompanyProperty.All[indexPath.section]
        if indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1 {
            let cell = cellWithIdentifier("TitleDetailTableViewCell") as! TitleDetailTableViewCell
            cell.titleLabel?.text = CompanyFilter[property][indexPath.row]
            cell.detailLabel?.text = "\(numberOfCompaniesForPropertyValue(property, value: CompanyFilter[property][indexPath.row]))"
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
    
    
    func presentResetAllFiltersAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Reset Filter", style: .Destructive, handler: {
            action in
            self.resetFilter()
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            action in
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentCopyFilterAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let prompt = CopyFilter.userDefaultsKey == MatchFilter.userDefaultsKey ? "Copy Match Filter" : "Copy Catalogue Filter"
        alertController.addAction(UIAlertAction(title: prompt, style: UIAlertActionStyle.Destructive, handler: {
            action in
            self.copyFilter()
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            action in
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) as? AddCompanyPropertyTableViewCell != nil {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("AddPropertySegue", sender: self)
            }
        }
        if indexPath.section == numberOfSectionsInTableView(tableView) - 1 {
            deselectSelectedCell()
            if indexPath.row == 0 {
                presentCopyFilterAlert()
            } else {
                presentResetAllFiltersAlert()
            }
        }
    }
}

class AddCompanyPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
