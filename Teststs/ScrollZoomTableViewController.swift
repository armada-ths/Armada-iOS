import UIKit

class FixedHeaderTableViewController: UITableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func initHeaderView() {
        print("Initing header view")
        if tableView.tableHeaderView != nil {
            headerView = tableView.tableHeaderView
            tableView.tableHeaderView = nil
        }
        if headerHeight == 0 {
            headerHeight = headerView.frame.height
        }
        tableView.addSubview(headerView)
        tableView.sendSubviewToBack(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight+navigationBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -(headerHeight+navigationBarHeight))
        updateHeaderView()
    }

    
    var navigationBarHeight: CGFloat {
        if parentViewController == nil { return 0 }
        return (parentViewController as? ArmadaViewController != nil) ? -64 : 64
    }
    
    func updateHeaderView() {
        if headerView == nil {
            return
        }
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        let difference = -tableView.contentOffset.y - headerHeight - max(navigationBarHeight,0)
        if difference > 0  {
            headerRect.origin.y = -headerHeight - difference
        }
        headerView.frame = headerRect
    }
    var headerView: UIView!
    
    var headerHeight: CGFloat = 0
    
    var headerMaskLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        initHeaderView()
    }
    

    
}
