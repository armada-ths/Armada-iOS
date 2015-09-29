import UIKit

class ScrollZoomTableViewController: UITableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func initHeaderView() {
        print("Initing header view")
        headerView = tableView.tableHeaderView
//        headerView.layoutIfNeeded()
        if headerHeight == 0 {
            headerHeight = headerView.frame.height
        }
        
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.sendSubviewToBack(headerView)

        
        
        tableView.contentInset = UIEdgeInsets(top: headerHeight+navigationBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -(headerHeight+navigationBarHeight))
        updateHeaderView()
    }
    
    var navigationBarHeight: CGFloat {   
        return (parentViewController as? ArmadaViewController != nil) ? -64 : 64
    }
    
    func updateHeaderView() {

        
        

        if headerView == nil {
            return
        }
        
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        
        let difference = -tableView.contentOffset.y - headerHeight - max(navigationBarHeight,0)
        
        if difference > 0  {
//            print("Difference: \(difference), tableView.contentOffset.y: \(tableView.contentOffset.y)")
            headerRect.origin.y =  -headerHeight - difference
//            headerRect.size.height = headerHeight + difference
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
