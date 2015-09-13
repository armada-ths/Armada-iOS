import UIKit

class NewsDetailTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var publicationDateLabel: UILabel!
    

    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        titleLabel.text = selectedNewsItem!.title
        publicationDateLabel.text = selectedNewsItem!.publishedDate.formatWithStyle(.LongStyle)

        //let html = "<p>" + selectedNewsItem!.content + "</p>" + "<style>p { font-family: \"helvetica neue\"; font-weight: 300; font-size: 18px; padding: 0; margin: 0; color: #4c4c4c; line-height: 25px;  }</style>"
        //let attr = try! NSAttributedString(data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        
        
        contentTextView.attributedText = selectedNewsItem!.content.attributedHtmlString ?? NSAttributedString(string: selectedNewsItem!.content)
        
//        contentTextView.text = selectedNewsItem!.content


    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
