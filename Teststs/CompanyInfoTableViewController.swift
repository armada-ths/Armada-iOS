import UIKit

class CompanyInfoTableViewController: UITableViewController {
    
    class DataSource: ArmadaTableViewDataSource<ArmadaFieldInfo> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(_ callback: @escaping (Response<[[ArmadaFieldInfo]]>) -> Void) {
            ArmadaApi.armadaFieldInfosFromServer() { response in
                 OperationQueue.main.addOperation {
                    callback(response.map { [$0]})
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTypeTableViewCell", for: indexPath) as! CompanyTypeTableViewCell
            let armadaFieldInfo = self[indexPath]
            cell.icon.image = armadaFieldInfo.armadaField.image
            cell.titleLabel.text = armadaFieldInfo.title
            cell.descriptionLabel.attributedText = armadaFieldInfo.description.attributedHtmlString
            return cell
        }
    }
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataSource(tableViewController: self)
        tableView.dataSource = dataSource
        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
