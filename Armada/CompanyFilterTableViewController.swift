import UIKit

enum CompanyProperty: CustomStringConvertible {
    case programmes, jobTypes, continents, workFields, companyValues
    
    static let All = [programmes, jobTypes, continents, workFields, companyValues]
    
    var penalty: Double {
        switch self {
        case .programmes: return 0.2
        case .jobTypes: return 0.6
        case .continents: return 0.9
        case .workFields: return 0.4
        case .companyValues: return 0.9
        }
    }
    
    var values: [String] {
        switch self {
        case .programmes: return ArmadaApi.programmes
        case .jobTypes: return ArmadaApi.jobTypes
        case .continents: return ArmadaApi.continents
        case .workFields: return ArmadaApi.workFields
        case .companyValues: return ArmadaApi.companyValues
        }
    }
    
    var description: String {
        switch self {
        case .programmes: return "Programme"
        case .jobTypes: return "Job Type"
        case .continents: return "Continent"
        case .workFields: return "Work Field"
        case .companyValues: return "Company Value"
        }
    }
}

extension Company {
    subscript(companyProperty: CompanyProperty) -> [String] {
        switch companyProperty {
        case .programmes: return programmes.map {$0.programme}
        case .jobTypes: return jobTypes.map {$0.jobType}
        case .continents: return continents.map {$0.continent}
        case .workFields: return workFields.map {$0.workField}
        case .companyValues: return companyValues.map {$0.companyValue}
        }
    }
    
    func hasArmadaFieldType(_ armadaField: ArmadaField) -> Bool {
        switch armadaField {
        case .Startup:
            return isStartup
        case .Diversity:
            return likesEquality
        case .Sustainability:
            return likesEnvironment
        }
    }
}

func numberOfCompaniesForPropertyValue(_ property: CompanyProperty, value: String) -> Int {
    return ArmadaApi.companies.filter({ ($0[property]).contains(value) }).count
}



class CompanyFilterTableViewController: UITableViewController, CompanyBoolCellDelegate {
    
    var CompanyFilter: _CompanyFilter! = nil
    var CopyFilter: _CompanyFilter! = nil
    var armadaPages: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArmadaApi.pagesFromServer {
            if case .success(let armadaPages) = $0 {
                OperationQueue.main.addOperation {
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
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(CompanyFilter.description)
        print("VIEW WILL APPEAR")
        updateTitle()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CompanyProperty.All.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == numberOfSections(in: tableView) - 2 { return armadaFields.count }
        if section == numberOfSections(in: tableView) - 1 { return 2 }
        return CompanyFilter[CompanyProperty.All[section]].count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Programmes", "Job Types", "Continents", "Work Fields", "Company Values", "", ""][section]
    }
    
    func cellWithIdentifier(_ identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifier)!
    }
    
    func updateTitle() {
        navigationItem.title = "\(CompanyFilter.filteredCompanies.count) of \(ArmadaApi.companies.count) Companies"
    }
    
    let armadaFields = ArmadaField.All
    
    
    func armadaField(_ armadaField: ArmadaField, isOn: Bool) {
        if isOn {
            CompanyFilter.armadaFields += [armadaField]
        } else {
            CompanyFilter.armadaFields = CompanyFilter.armadaFields.filter { $0 != armadaField }
        }
        updateTitle()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == numberOfSections(in: tableView) - 1 {
            if (indexPath as NSIndexPath).row == 0 {
                return cellWithIdentifier(CompanyFilter.userDefaultsKey == MatchFilter.userDefaultsKey ? "copyCatalogueCell" : "copyMatchCell")
            } else {
                return cellWithIdentifier("resetAllFiltersCell")
            }
        }
        
        if (indexPath as NSIndexPath).section == numberOfSections(in: tableView) - 2 {
            let cell = cellWithIdentifier("CompanyBoolCell") as! CompanyBoolCell
            let armadaField = armadaFields[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = Json(object: armadaPages)[armadaField.rawValue]["title"].string ?? armadaField.title
            cell.iconImageView.image = armadaField.image
            cell.valueSwitch.isOn = CompanyFilter.armadaFields.contains(armadaField)
            cell.armadaField = armadaField
            cell.delegate = self
            let companies = ArmadaApi.companies.filter { $0.hasArmadaFieldType(armadaField) }
            cell.numberOfJobsLabel.text = "\(companies.count)"
            
            return cell
        }
        
        let property = CompanyProperty.All[(indexPath as NSIndexPath).section]
        if (indexPath as NSIndexPath).row < tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section) - 1 {
            let cell = cellWithIdentifier("TitleDetailTableViewCell") as! TitleDetailTableViewCell
            cell.titleLabel?.text = CompanyFilter[property][(indexPath as NSIndexPath).row]
            cell.detailLabel?.text = "\(numberOfCompaniesForPropertyValue(property, value: CompanyFilter[property][(indexPath as NSIndexPath).row]))"
            return cell
        } else {
            let cell = cellWithIdentifier("AddPropertyCell") as! AddCompanyPropertyTableViewCell
            cell.addButton.setTitle("Add \(property)", for: UIControlState())
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath as NSIndexPath).row < tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section) - 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let property = CompanyProperty.All[(indexPath as NSIndexPath).section]
            let value = CompanyFilter[property][(indexPath as NSIndexPath).row]
            CompanyFilter[property] = CompanyFilter[property].filter { $0 != value }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            updateTitle()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let viewController = (segue.destination as? UINavigationController)?.childViewControllers.first as? AddCompanyPropertyTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
                viewController.property = CompanyProperty.All[(indexPath as NSIndexPath).section]
                viewController.companyFilter = CompanyFilter
        }
    }
    
    
    func presentResetAllFiltersAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Reset Filter", style: .destructive, handler: {
            action in
            self.resetFilter()
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func presentCopyFilterAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let prompt = CopyFilter.userDefaultsKey == MatchFilter.userDefaultsKey ? "Copy Match Filter" : "Copy Catalogue Filter"
        alertController.addAction(UIAlertAction(title: prompt, style: UIAlertActionStyle.destructive, handler: {
            action in
            self.copyFilter()
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
//            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) as? AddCompanyPropertyTableViewCell != nil {
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "AddPropertySegue", sender: self)
            }
        }
        if (indexPath as NSIndexPath).section == numberOfSections(in: tableView) - 1 {
            deselectSelectedCell()
            if (indexPath as NSIndexPath).row == 0 {
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
