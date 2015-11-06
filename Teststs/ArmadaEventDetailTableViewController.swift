import UIKit


public func <(x: NSDate, y: NSDate) -> Bool {
    return x.timeIntervalSince1970 < y.timeIntervalSince1970
}

class ArmadaEventDetailTableViewController: ScrollZoomTableViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UITextView!
    
    @IBOutlet weak var signupLabel: UILabel!
    
    var armadaEvent: ArmadaEvent!
    
    override func viewDidLoad() {
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        super.viewDidLoad()
        
        dayLabel.text = armadaEvent.startDate.format("d")
        monthLabel.text = armadaEvent.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attrString = NSMutableAttributedString(string: armadaEvent.summary)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        summaryLabel.attributedText = attrString
        summaryLabel.textContainer.lineFragmentPadding = 0
        summaryLabel.textContainerInset = UIEdgeInsetsZero
        if let text = armadaEvent.summary.attributedHtmlString{
            summaryLabel.attributedText = text
        }else{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            let attrString = NSMutableAttributedString(string: armadaEvent.summary)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            summaryLabel.attributedText = attrString
        }
            
        if let imageUrl =  armadaEvent.imageUrl {
            eventImageView.loadImageFromUrl(imageUrl.absoluteString)
        }
        titleLabel.text = armadaEvent.title
        signupLabel.textColor = UIColor.lightGrayColor()
        tableView.allowsSelection = false
        
        if armadaEvent.startDate < NSDate() || armadaEvent.signupEndDate != nil && armadaEvent.signupEndDate! < NSDate() {
            signupLabel.text = "Registration is over"
        } else {
            if let signupStartDate =  armadaEvent.signupStartDate,
                let signupLink = armadaEvent.signupLink where !signupLink.isEmpty,
                let _ = NSURL(string: signupLink) {
                if signupStartDate < NSDate() {
                    signupLabel.text = "Sign Up"
                    signupLabel.textColor = ColorScheme.armadaGreen
                    tableView.allowsSelection = true
                } else {
                    signupLabel.text = "Registration starts at \(signupStartDate.readableString)"
                }
            } else {
                signupLabel.text = "Registration TBA"
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && tableView.allowsSelection {
            if let signupUrl = armadaEvent.signupLink,
                let url = NSURL(string: signupUrl) {
                    UIApplication.sharedApplication().openURL(url)
                    deselectSelectedCell()
            }
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
