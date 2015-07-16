import UIKit

var selectedNewsItem:News!

class NewsTableViewController: UITableViewController {
    var readArmadaNews = [String]()
    let news: [News] = {
        do {
            return try DataDude.newsFromServer()
        } catch {
            print(error)
            return []
        }
        }()
    
    var imageView: UIImageView!
    
    var headerView: UIView!
    
    var headerHeight: CGFloat = 200
    
    var headerMaskLayer: CAShapeLayer!
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        let difference =  -tableView.contentOffset.y - headerHeight - 64
        if difference > 0  {
            headerRect.origin.y =  -headerHeight - difference
            headerRect.size.height = headerHeight + difference
        }
        headerView.frame = headerRect
    
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-50))
        headerMaskLayer?.path = path.CGPath
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func tap(recognizer: UITapGestureRecognizer) {
        print(recognizer.locationInView(headerView))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = tableView.tableHeaderView
        headerHeight = headerView.frame.height
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tap:")))
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.sendSubviewToBack(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        updateHeaderView()

        
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return tableView.dequeueReusableCellWithIdentifier("NewsBackgroundTableViewCell") as! UITableViewCell
//    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 203
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("NewsBackgroundTableViewCell", forIndexPath: indexPath) as! UITableViewCell
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        
        let newsItem = news[indexPath.row]
        cell.titleLabel.text = newsItem.title
        cell.descriptionLabel.text = newsItem.content
        
        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "d"
        
        cell.descriptionLabel.text = dayFormatter.stringFromDate(newsItem.publishedDate) + " " + monthFormatter.stringFromDate(newsItem.publishedDate)
        
        cell.isReadLabel.hidden = readArmadaNews.contains(newsItem.title)
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        selectedNewsItem = news[tableView.indexPathForSelectedRow!.row]
        if !readArmadaNews.contains(selectedNewsItem!.title) {
            readArmadaNews.append(selectedNewsItem!.title)
        }
        
        let contentWithoutHtml = (try! NSAttributedString(data: selectedNewsItem.content.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)).string
        
        selectedArmadaEvent = ArmadaEvent(title: selectedNewsItem.title, summary: contentWithoutHtml, location: "", startDate: selectedNewsItem.publishedDate, endDate: selectedNewsItem.publishedDate, signupLink: "")
        
    }
}
