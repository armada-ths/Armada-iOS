import UIKit

class AddCompanyPropertyTableViewController: UITableViewController {
    
    var values = [String]()
    var property: CompanyProperty!
    var companyFilter: _CompanyFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        values = property.values.filter { !companyFilter[property].contains($0) }
        
        title = "Add \(property)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        companyFilter[property] = companyFilter[property] + [values[(indexPath as NSIndexPath).row]]
        return indexPath
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailTableViewCell", for: indexPath) as! TitleDetailTableViewCell
        cell.titleLabel.text = values[(indexPath as NSIndexPath).row]
        cell.detailLabel.text = "\(ArmadaApi.numberOfCompaniesContainingValue(values[(indexPath as NSIndexPath).row], forProperty: property) ?? 0)"
        return cell
    }

}
