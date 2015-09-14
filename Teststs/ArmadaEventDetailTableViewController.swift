import UIKit


public func <(x: NSDate, y: NSDate) -> Bool {
    return x.timeIntervalSince1970 < y.timeIntervalSince1970
}

class ArmadaEventDetailTableViewController: ScrollZoomTableViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    
    override func viewDidLoad() {
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        super.viewDidLoad()
        let armadaEvent = selectedArmadaEvent!
        
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
        
        if let imageUrl =  selectedArmadaEvent!.imageUrl {
            eventImageView.loadImageFromUrl(imageUrl.absoluteString)
        }
        titleLabel.text = selectedArmadaEvent?.title
        signupLabel.textColor = UIColor.lightGrayColor()
        tableView.allowsSelection = false
        
        if armadaEvent.startDate < NSDate() || armadaEvent.signupEndDate != nil && armadaEvent.signupEndDate! < NSDate() {
            signupLabel.text = "Registration for this event is over"
        } else {
            if let signupStartDate =  armadaEvent.signupStartDate {
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
            if let url = NSURL(string: selectedArmadaEvent!.signupLink) {
                UIApplication.sharedApplication().openURL(url)
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
