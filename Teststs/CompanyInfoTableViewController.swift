import UIKit


class CompanyInfoTableViewController: UITableViewController {
    
    class DataSource: ArmadaTableViewDataSource<ArmadaFieldInfo> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[ArmadaFieldInfo]]> -> Void) {
            ArmadaApi.armadaFieldInfosFromServer() {
                callback($0.map { [$0]})
            }
        }
        

        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTypeTableViewCell", forIndexPath: indexPath) as! CompanyTypeTableViewCell
            let armadaFieldInfo = values[indexPath.section][indexPath.row]
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
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
