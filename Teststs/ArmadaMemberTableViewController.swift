import UIKit

class ArmadaMemberTableViewController: UITableViewController {
    
    @IBOutlet weak var memberImageView: UIImageView!
    
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var member: ArmadaMember!

    override func viewDidLoad() {
        super.viewDidLoad()
        memberImageView.loadImageFromUrl(member.imageUrl.absoluteString)
        nameLabel.text = member.name
        roleLabel.text = member.role
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
