import UIKit

class ArmadaEventDetailTableViewController: ScrollZoomTableViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        print("VIEW DID LOAD!!!")
        super.viewDidLoad()
        if tableView.tableHeaderView != nil {
            initHeaderView()
        }
        
        if eventImageView != nil {
            eventImageView.image = selectedArmadaEvent?.image
        }
        
        if titleLabel != nil {
            titleLabel.text = selectedArmadaEvent?.title
        }

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell

        if let selectedArmadaEvent=selectedArmadaEvent{
            
            cell.dayLabel.text = selectedArmadaEvent.startDate.format("d")
            cell.monthLabel.text = selectedArmadaEvent.startDate.format("MMM").uppercaseString.stringByReplacingOccurrencesOfString(".", withString: "")
            
            
            cell.summaryLabel.text = selectedArmadaEvent.summary
            // Configure the cell...
        }
        
        if let news = selectedNewsItem {
            cell.titleLabel.text = news.title
            cell.summaryLabel.text = news.content
        }
        return cell
    }



}
