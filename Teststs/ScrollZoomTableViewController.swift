import UIKit

class ScrollZoomTableViewController: UITableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func initHeaderView() {
        headerView = tableView.tableHeaderView
        headerHeight = headerView.frame.height
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.sendSubviewToBack(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        if headerView == nil {
            return
        }
        
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        let difference =  -tableView.contentOffset.y - headerHeight - 64
        if difference > 0  {
            headerRect.origin.y =  -headerHeight - difference
            headerRect.size.height = headerHeight + difference
        }
        headerView.frame = headerRect
    }
    var headerView: UIView!
    
    var headerHeight: CGFloat = 200
    
    var headerMaskLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
}
