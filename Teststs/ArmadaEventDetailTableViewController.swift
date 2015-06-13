import UIKit

class ArmadaEventDetailTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArmadaEventTableViewCell", forIndexPath: indexPath) as! ArmadaEventTableViewCell

        if let selectedArmadaEvent=selectedArmadaEvent{
            cell.titleLabel.text = selectedArmadaEvent.title
            
            let monthFormatter = NSDateFormatter()
            monthFormatter.dateFormat = "MMM"
            
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateFormat = "d"
            
            cell.dayLabel.text = dayFormatter.stringFromDate(selectedArmadaEvent.startDate)
            cell.monthLabel.text = monthFormatter.stringFromDate(selectedArmadaEvent.startDate).uppercaseString
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "E dd MMMM"
            //        cell.dateLabel.text = dateFormatter.stringFromDate(selectedArmadaEvent!.startDate)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            cell.eventImageView.image = UIImage(named: selectedArmadaEvent.title)
//            cell.locationLabel.text = selectedArmadaEvent.location + ", " + timeFormatter.stringFromDate(selectedArmadaEvent.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent.endDate)
            
            if selectedArmadaEvent.location.isEmpty {
                cell.locationLabel.text = timeFormatter.stringFromDate(selectedArmadaEvent.startDate)
            }
            //        cell.timeLabel.text = timeFormatter.stringFromDate(selectedArmadaEvent!.startDate) + " - " + timeFormatter.stringFromDate(selectedArmadaEvent!.endDate)
            
            cell.summaryLabel.text = selectedArmadaEvent.summary
            // Configure the cell...
        }
        return cell
    }



}
