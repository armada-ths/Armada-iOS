import UIKit

class CompanyInfoTableViewController: UITableViewController {
    
    let armadaFields = _ArmadaApi.ArmadaField.All
    var armadaPages: AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ArmadaApi.pagesFromServer { response in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch response {
                case .Success(let armadaPages):
                    self.armadaPages = armadaPages
                    self.tableView.reloadData()
                case .Error(let error):
                    self.showEmptyMessage(true, message: (error as NSError).localizedDescription)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return armadaPages == nil ? 0 : armadaFields.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTypeTableViewCell", forIndexPath: indexPath) as! CompanyTypeTableViewCell
        let armadaField = armadaFields[indexPath.row]
        cell.icon.image = armadaField.image
        cell.titleLabel.text = armadaPages?[armadaField.rawValue]??["title"] as? String
        cell.descriptionLabel.attributedText = (armadaPages?[armadaField.rawValue]??["app_text"] as? String)?.attributedHtmlString
        return cell
    }
}
