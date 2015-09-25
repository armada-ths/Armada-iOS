import UIKit

class NewsDetailTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var publicationDateLabel: UILabel!
    
    var news: News!
    

    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        titleLabel.text = news.title
        publicationDateLabel.text = news.publishedDate.formatWithStyle(.LongStyle)
        contentTextView.attributedText = news.content.attributedHtmlString ?? NSAttributedString(string: news.content)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
