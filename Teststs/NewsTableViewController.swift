import UIKit

class NewsTableViewController: FixedHeaderTableViewController {
    
    class ArmadaNewsTableViewDataSource: ArmadaTableViewDataSource<News> {
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        // For some reason - this offset has to be added if the first request fails, no fucking idea why
        var shit: CGFloat = 0
        
        override func updateFunc(_ callback: @escaping (Response<[[News]]>) -> Void) {
            ArmadaApi.newsFromServer { response in
                OperationQueue.main.addOperation {
                    switch response {
                    case .success:
                        if self.values.isEmpty {
                            let tableViewController = (self.tableViewController as! FixedHeaderTableViewController)
                            tableViewController.headerView.isHidden = false
                            tableViewController.tableView.contentInset = UIEdgeInsets(top: tableViewController.headerHeight + self.shit, left: 0, bottom: 0, right: 0)
                            tableViewController.tableView.contentOffset = CGPoint(x: 0, y: -(tableViewController.headerHeight))
                        }
                    case .error: self.shit = 64
                    }
                    callback(response.map { [$0] })
                }
                
            }
        }
        
        override var hasNavigationBar: Bool {
            return false
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let newsItem = self[indexPath]
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            cell.titleLabel.text = newsItem.title
            cell.descriptionLabel.text = newsItem.publishedDate.formatWithStyle(.long)
            cell.isReadLabel.isHidden = NewsTableViewController.readArmadaNews.contains(newsItem.title)
            return cell
        }
    }
    
    
    static let readArmadaNewsKey = "readArmadaNews"
    static var readArmadaNews: [String] {
        get {
            return UserDefaults.standard[readArmadaNewsKey] as? [String] ?? []
        }
        set {
            UserDefaults.standard[readArmadaNewsKey] = newValue as AnyObject?
        }
    }
    
    override func updateHeaderView() {
        super.updateHeaderView()
        let headerRect = headerView.frame
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height-50))
        headerMaskLayer?.path = path.cgPath
    }
    
    var dataSource: ArmadaNewsTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = ArmadaNewsTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        headerView.isHidden = true
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let controller = segue.destination as? NewsDetailTableViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let news = dataSource[indexPath]
                controller.news = news
                if !NewsTableViewController.readArmadaNews.contains(news.title) {
                    NewsTableViewController.readArmadaNews.append(news.title)
                }
                deselectSelectedCell()
        }
    }
}
