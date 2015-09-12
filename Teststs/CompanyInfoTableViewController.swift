import UIKit

class CompanyInfoTableViewController: UITableViewController {
    
//    let companyTypes: [(image: UIImage, title: String, description: String)] = [
//            (UIImage(named: "Leaf")!, title: "Climate Compensation", description: "This icon indicates that the company has donated money for climate compensation"),
//            (UIImage(named: "Rocket")!, title: "Startup", description: "This icon indicates that the company is a company"),
//            (UIImage(named: "Tree")!, title: "Environmental Exhibitor", description: "This icon indicates that the company is a an environment exhibitor"),
//    ]
    
    let companyTypes: [(image: UIImage, slug: String)] = [
        (UIImage(named: "Leaf")!, "icon_climate_compensation"),
        (UIImage(named: "Rocket")!, "icon_startup"),
        (UIImage(named: "Tree")!, "icon_sustainability"),
        (UIImage(named: "Leaf")!, "icon_diversity"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return companyTypes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTypeTableViewCell", forIndexPath: indexPath) as! CompanyTypeTableViewCell
        
        let companyType = companyTypes[indexPath.row]
        cell.icon.image = companyType.image
        cell.titleLabel.text = (armadaPages[companyType.slug]??["title"] as? String) ?? ""
        cell.descriptionLabel.text = (armadaPages[companyType.slug]??["app_text"] as? String) ?? ""
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
