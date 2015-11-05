import UIKit

class NewsTableViewController: ScrollZoomTableViewController {
    
    class ArmadaNewsTableViewDataSource: ArmadaTableViewDataSource<News> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[News]]> -> Void) {
            ArmadaApi.newsFromServer {
                callback($0.map { [$0] })
            }
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let newsItem = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
            cell.titleLabel.text = newsItem.title
            cell.descriptionLabel.text = newsItem.publishedDate.formatWithStyle(.LongStyle)
            cell.isReadLabel.hidden = NewsTableViewController.readArmadaNews.contains(newsItem.title)
            return cell
        }
    }
    
    static var readArmadaNews: [String] {
        get {
            return NSUserDefaults.standardUserDefaults()["readArmadaNews"] as? [String] ?? []
        }
        set {
            NSUserDefaults.standardUserDefaults()["readArmadaNews"] = newValue
        }
    }
    
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
    
    
    var dataSource: ArmadaNewsTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = ArmadaNewsTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let controller = segue.destinationViewController as? NewsDetailTableViewController,
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let news = dataSource.values[indexPath.section][indexPath.row]
                controller.news = news
                if !NewsTableViewController.readArmadaNews.contains(news.title) {
                    NewsTableViewController.readArmadaNews.append(news.title)
                }
        }
    }
}
