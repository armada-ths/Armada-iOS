import UIKit

class ArmadaEventDetailTableViewController: ScrollZoomTableViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        super.viewDidLoad()
        
        if !selectedArmadaEvent!.signupLink.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Signup", style: .Plain, target: self, action: Selector("signup:"))
        }
        
        dayLabel.text = selectedArmadaEvent!.startDate.format("d")
        monthLabel.text = selectedArmadaEvent!.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attrString = NSMutableAttributedString(string: selectedArmadaEvent!.summary)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        summaryLabel.attributedText = attrString

        if let text = selectedArmadaEvent?.summary.attributedHtmlString{
            summaryLabel.attributedText = text
        }else{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            let attrString = NSMutableAttributedString(string: selectedArmadaEvent!.summary)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            summaryLabel.attributedText = attrString
        }
        
        eventImageView.image = selectedArmadaEvent?.image
        titleLabel.text = selectedArmadaEvent?.title
    }
    
    func signup(sender: AnyObject) {
        if let url = NSURL(string: selectedArmadaEvent!.signupLink) {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func signupButtonClicked(sender: UIButton) {
        if let url = NSURL(string: selectedArmadaEvent!.signupLink) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
