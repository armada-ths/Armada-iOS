import UIKit

class ArmadaTableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    var values = [[T]]()
    weak var tableViewController: UITableViewController?
    
    let separatorStyle: UITableViewCellSeparatorStyle
    
    init(tableViewController: UITableViewController) {
        self.separatorStyle = tableViewController.tableView.separatorStyle
        super.init()
        self.tableViewController = tableViewController
        tableViewController.tableView.separatorStyle = .None
    }
    
    subscript(indexPath: NSIndexPath) -> T {
        return values[indexPath.section][indexPath.row]
    }
    
    var hasNavigationBar: Bool {
        return true
    }
    
    func refresh(refreshControl: UIRefreshControl? = nil) {
        if refreshControl == nil {
            tableViewController?.tableView.startActivityIndicator(hasNavigationBar: hasNavigationBar)
            tableViewController?.showEmptyMessage(false, message: "")
            self.tableViewController?.tableView.separatorStyle = .None
        }
        updateFunc { response in
                switch response {
                case .Success(let values):
                    self.values = values
                    self.tableViewController?.showEmptyMessage(self.values.isEmpty, message: "Nothing to be seen")
                    print("Refreshed")
                case .Error(let error):
                    self.tableViewController?.showEmptyMessage(self.values.isEmpty, message: (error as NSError).localizedDescription)
                    if !self.values.isEmpty {
                        let alertController = UIAlertController(title: nil, message: (error as NSError).localizedDescription, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.tableViewController?.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
                self.tableViewController?.refreshControl?.endRefreshing()
                self.tableViewController?.tableView.separatorStyle = self.values.isEmpty ? .None : self.separatorStyle
                self.tableViewController?.tableView.reloadData()
                self.tableViewController?.tableView.stopActivityIndicator()
                self.tableViewController?.refreshControl = UIRefreshControl()
                self.tableViewController?.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    var isEmpty: Bool {
        return values.isEmpty
    }
    
    func updateFunc(callback: Response<[[T]]> -> Void) {}
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        assert(false)
        return tableView.dequeueReusableCellWithIdentifier("")!
    }
    
}

