import UIKit

let CompanyFilter = _CompanyFilter()
class _CompanyFilter {
    
    private init() {}
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    var education: String? {
        get { return Ω["CompanyFilterEducation"] as? String }
        set {  Ω["CompanyFilterEducation"] = newValue }
    }
    
    var jobs: [String] {
        get { return Ω["CompanyFilterJobs"] as? [String] ?? [] }
        set { Ω["CompanyFilterJobs"] = newValue }
    }
    
    var applyFilter: Bool {
        get { return Ω["CompanyFilterApplyFilter"] as? Bool ?? false }
        set { Ω["CompanyFilterApplyFilter"] = newValue }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = DataDude.companies
        if let education = CompanyFilter.education {
            filteredCompanies = filteredCompanies.filter { contains($0.programmes, education) }
        }
        filteredCompanies = Array(Set(reduce(CompanyFilter.jobs, [Company]()) { (companies, job) in
            return companies + filteredCompanies.filter { contains($0.jobTypes, job) }
            }))
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
    @IBAction func clickedApplyFilter(sender: UISwitch) {
        CompanyFilter.applyFilter = sender.on
    }
    
    // MARK: - Table view data source
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    let jobs = DataDude.jobs
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,1,0,jobs.count,1][section]
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["", "I am studying...", "", "...And looking for...",
            "...At companies that are..."][section]
    }
    
    func cellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    }
    
    func updateTitle() {
        navigationItem.title = "\(CompanyFilter.filteredCompanies.count) of \(DataDude.companies.count) companies"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = cellWithIdentifier("ApplyFilterTableViewCell")
            (cell as! ApplyFilterTableViewCell).applyFilterSwitch.on = CompanyFilter.applyFilter
        case 1:
            let specialCell = cellWithIdentifier("SelectedEducationTableViewCell") as! SelectedEducationTableViewCell
            if let zebra = CompanyFilter.education?.componentsSeparatedByString(" in ") where zebra.count == 2 {
                specialCell.fieldLabel.text = zebra[1]
                specialCell.degreeLabel.text = zebra[0]
            } else {
                specialCell.fieldLabel.text = "Not Selected"
                specialCell.degreeLabel.text = ""
            }
            cell = specialCell
            
            cell.textLabel?.font = UIFont.systemFontOfSize(12)
        case 2:
            if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
                return cellWithIdentifier("AddAttributeCell")
            } else {
                cell = cellWithIdentifier("AttributeCell")
            }
        case 3:
            cell = cellWithIdentifier("JobCell")
            let job = jobs[indexPath.row]
            let numJobs = DataDude.companies.filter({ contains($0.jobTypes, job) }).count
//            cell.textLabel?.text = job + " (\(numJobs))"
//            cell.accessoryType = contains(CompanyFilter.jobs, job) ? .Checkmark : .None
//            cell.textLabel?.font = UIFont.systemFontOfSize(14)
            
            
            (cell as! SelectJobTableViewCell).jobName = job
            (cell as! SelectJobTableViewCell).jobNameLabel.text = job + " (\(numJobs))"
            (cell as! SelectJobTableViewCell).jobSwitch.on = contains(CompanyFilter.jobs, job)
            (cell as! SelectJobTableViewCell).controller = self
            
        default: cell = cellWithIdentifier("InternationalCell")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
        if indexPath.section == 3 {
            let job = jobs[indexPath.row]
//            if contains(CompanyFilter.jobs, job) {
//                CompanyFilter.jobs = CompanyFilter.jobs.filter({ $0 != job })
//            } else {
//                CompanyFilter.jobs = CompanyFilter.jobs + [job]
//            }
            tableView.reloadData()
        }
        updateTitle()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4 {
            return 54
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}
