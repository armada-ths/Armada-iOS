import UIKit

var selectedNewsItem:News!

class NewsTableViewController: ScrollZoomTableViewController {
    var readArmadaNews: [String] {
        get {
            return NSUserDefaults.standardUserDefaults()["readArmadaNews"] as? [String] ?? []
        }
        set {
            NSUserDefaults.standardUserDefaults()["readArmadaNews"] = newValue
        }
    }
    
    
    
    
    let news: [News] = {
        do {
            return try DataDude.newsFromServer()
        } catch {
            print(error)
            return []
        }
        }()
    
    
    override func updateHeaderView() {
        super.updateHeaderView()
                let headerRect = headerView.frame
                let path = UIBezierPath()
                path.moveToPoint(CGPoint(x: 0, y: 0))
                path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
                path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
                path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-50))
                headerMaskLayer?.path = path.CGPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        self.clearsSelectionOnViewWillAppear = true
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        updateHeaderView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        let newsItem = news[indexPath.row]
        cell.titleLabel.text = newsItem.title
        cell.descriptionLabel.text = newsItem.publishedDate.formatWithStyle(.LongStyle)
        cell.isReadLabel.hidden = readArmadaNews.contains(newsItem.title)
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let indexPath = tableView.indexPathForSelectedRow {
        selectedNewsItem = news[indexPath.row]
        if !readArmadaNews.contains(selectedNewsItem!.title) {
            readArmadaNews.append(selectedNewsItem!.title)
        }
        
//        let contentWithoutHtml = (try! NSAttributedString(data: selectedNewsItem.content.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)).string
        
//        selectedArmadaEvent = ArmadaEvent(title: selectedNewsItem.title, summary: contentWithoutHtml, location: "", startDate: selectedNewsItem.publishedDate, endDate: selectedNewsItem.publishedDate, signupLink: "")
    }
    }
}
