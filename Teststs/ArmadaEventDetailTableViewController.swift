import UIKit

class ArmadaEventDetailTableViewController: FixedHeaderTableViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UITextView!
    @IBOutlet weak var signupLabel: UILabel!
    
    var armadaEvent: ArmadaEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryLabel.textContainer.lineFragmentPadding = 0
        summaryLabel.textContainerInset = UIEdgeInsets.zero

        var moreInfo = "<p><strong>When: </strong>\(armadaEvent.startDate.readableString)</p>"
        moreInfo += "<p><strong>Where: </strong>\((armadaEvent.location ?? "").isEmpty ? "TBA" : armadaEvent.location!)</p>"
        if let html = (moreInfo + armadaEvent.summary).attributedHtmlString {
            summaryLabel.attributedText = html
        } else {
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
        titleLabel.text = ""
        title = armadaEvent.title
        signupLabel.textColor = UIColor.lightGray
        tableView.allowsSelection = false
        
        signupLabel.text = armadaEvent.signupStateString
        if armadaEvent.signupState == .now {
//            signupLabel.text = "Sign Up"
            signupLabel.textColor = ColorScheme.armadaGreen
            tableView.allowsSelection = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 && tableView.allowsSelection {
            if let signupUrl = armadaEvent.signupLink,
                let url = URL(string: signupUrl) {
                    UIApplication.shared.openURL(url)
                    deselectSelectedCell()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
